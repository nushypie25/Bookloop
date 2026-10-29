 require('dotenv').config();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const crypto = require('crypto');
const transporter = require('./mailer');

 const express = require('express');

const db = require('./db');

const app = express();

app.use(express.json());

app.get('/', (req, res) => {
res.send('BookLoop Backend is Running!');
});

app.get('/api/books', (req, res) => {
const page = Math.max(1, parseInt(req.query.page) || 1);
const limit = Math.max(1, parseInt(req.query.limit) || 5);
const offset = (page - 1) * limit;


const search = (req.query.search || '').trim();

let whereClause = '';
let queryParams = [];

// Search by title, author, or category
if (search) {
    whereClause = `
        WHERE title LIKE ?
        OR author LIKE ?
        OR category LIKE ?
    `;

    const searchValue = `%${search}%`;
    queryParams = [searchValue, searchValue, searchValue];
}

// Count all matching books before pagination
const countSql = `
    SELECT COUNT(*) AS total
    FROM books
    ${whereClause}
`;

db.query(countSql, queryParams, (err, countResults) => {
    if (err) {
        console.log(err);
        return res.status(500).json({
            message: 'Database error'
        });
    }

    const totalBooks = countResults[0].total;
    const totalPages = Math.ceil(totalBooks / limit);

    // Fetch the requested page of matching books
    const sql = `
        SELECT *
        FROM books
        ${whereClause}
        LIMIT ? OFFSET ?
    `;

    const values = [...queryParams, limit, offset];

    db.query(sql, values, (err, results) => {
        if (err) {
            console.log(err);
            return res.status(500).json({
                message: 'Database error'
            });
        }

        res.json({
            page: page,
            limit: limit,
            search: search,
            totalBooks: totalBooks,
            totalPages: totalPages,
            books: results
        });
    });
});


});


app.post('/api/books', (req, res) => {

console.log(req.body);

const {
    title,
    author,
    price,
    category,
    description,
    image_url
} = req.body;

const sql = `
    INSERT INTO books
    (title, author, price, category, description, image_url)
    VALUES (?, ?, ?, ?, ?, ?)
`;

const values = [
    title,
    author,
    price,
    category,
    description,
    image_url
];

db.query(sql, values, (err, result) => {

    if (err) {

        console.log(err);

        res.status(500).json({
            message: 'Book could not be added'
        });

    } else {

        res.status(201).json({
            message: 'Book added successfully!',
            bookId: result.insertId
        });

    }

});

});

const PORT = 3000;
// ---------------- BUY REQUEST API ----------------
app.post('/api/buy-requests', (req, res) => {
    const { book_title, book_price } = req.body;

    if (!book_title || !book_price) {
        return res.status(400).json({
            success: false,
            message: 'Book title and price are required'
        });
    }

    const sql = `
        INSERT INTO buy_requests (book_title, book_price)
        VALUES (?, ?)
    `;

    db.query(sql, [book_title, book_price], (err, result) => {
        if (err) {
            console.error('Buy request error:', err);

            return res.status(500).json({
                success: false,
                message: 'Failed to save buy request'
            });
        }

        res.status(201).json({
            success: true,
            message: 'Buy request saved successfully',
            requestId: result.insertId
        });
    });
});
// ---------------- EXCHANGE REQUEST API ----------------
app.post('/api/exchange-requests', (req, res) => {
    const { book_title } = req.body;

    if (!book_title) {
        return res.status(400).json({
            success: false,
            message: 'Book title is required'
        });
    }

    const sql = `
        INSERT INTO exchange_requests (book_title)
        VALUES (?)
    `;

    db.query(sql, [book_title], (err, result) => {
        if (err) {
            console.error('Exchange request error:', err);

            return res.status(500).json({
                success: false,
                message: 'Failed to save exchange request'
            });
        }

        res.status(201).json({
            success: true,
            message: 'Exchange request saved successfully',
            requestId: result.insertId
        });
    });
});
// ---------------- CONTACT SELLER API ----------------
app.post('/api/contact-messages', (req, res) => {
const { book_title, message } = req.body;


if (!book_title || !message || !message.trim()) {
    return res.status(400).json({
        success: false,
        message: 'Book title and message are required'
    });
}

const sql = `
    INSERT INTO contact_messages (book_title, message)
    VALUES (?, ?)
`;

db.query(sql, [book_title, message.trim()], (err, result) => {
    if (err) {
        console.error('Contact message error:', err);

        return res.status(500).json({
            success: false,
            message: 'Failed to save message'
        });
    }

    res.status(201).json({
        success: true,
        message: 'Message saved successfully',
        messageId: result.insertId
    });
});


});
// ---------------- GET CONTACT MESSAGES API ----------------
app.get('/api/contact-messages', (req, res) => {
    const sql = `
        SELECT id, book_title, message, status, sent_at
        FROM contact_messages
        ORDER BY sent_at DESC
    `;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Fetch messages error:', err);

            return res.status(500).json({
                success: false,
                message: 'Failed to fetch messages'
            });
        }

        res.json({
            success: true,
            messages: results
        });
    });
});
// Register a new user and send OTP by email
app.post('/api/auth/register', async (req, res) => {
  const { name, email, phone, password } = req.body;

  if (!name || !email || !password) {
    return res.status(400).json({
      message: 'Name, email and password are required.'
    });
  }

  if (password.length < 8) {
    return res.status(400).json({
      message: 'Password must be at least 8 characters long.'
    });
  }

  try {
    db.query(
      'SELECT id FROM users WHERE email = ?',
      [email],
      async (err, results) => {
        if (err) {
          console.error(err);
          return res.status(500).json({
            message: 'Database error.'
          });
        }

        if (results.length > 0) {
          return res.status(409).json({
            message: 'This email is already registered.'
          });
        }

        try {
          const hashedPassword = await bcrypt.hash(password, 10);
          const otp = crypto.randomInt(100000, 1000000).toString();
          const otpExpiry = new Date(Date.now() + 10 * 60 * 1000);

          db.query(
            `INSERT INTO users
             (name, email, phone, password, is_verified,
              verification_otp, otp_expires_at)
             VALUES (?, ?, ?, ?, 0, ?, ?)`,
            [
              name,
              email,
              phone || null,
              hashedPassword,
              otp,
              otpExpiry
            ],
            async (insertErr, result) => {
              if (insertErr) {
                console.error(insertErr);
                return res.status(500).json({
                  message: 'Could not register user.'
                });
              }

              try {
                await transporter.sendMail({
                  from: process.env.EMAIL_USER,
                  to: email,
                  subject: 'BookLoop Email Verification OTP',
                  text: `Your BookLoop verification code is ${otp}. It expires in 10 minutes.`
                });

                return res.status(201).json({
                  message: 'Registration successful. Check your email for OTP.'
                });
              } catch (mailErr) {
                console.error('Email sending failed:', mailErr.message);

                db.query(
                  'DELETE FROM users WHERE id = ?',
                  [result.insertId]
                );

                return res.status(500).json({
                  message: 'Could not send OTP email. Please try again.'
                });
              }
            }
          );
        } catch (error) {
          console.error(error);
          return res.status(500).json({
            message: 'Registration failed.'
          });
        }
      }
    );
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      message: 'Server error.'
    });
  }
});
// Verify email OTP
app.post('/api/auth/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({
      message: 'Email and OTP are required.'
    });
  }

  db.query(
    `SELECT id, name, email, is_verified,
            verification_otp, otp_expires_at
     FROM users
     WHERE email = ?`,
    [email],
    (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({
          message: 'Database error.'
        });
      }

      if (results.length === 0) {
        return res.status(404).json({
          message: 'Account not found.'
        });
      }

      const user = results[0];

      if (user.is_verified) {
        return res.status(400).json({
          message: 'This account is already verified.'
        });
      }

      if (
        !user.verification_otp ||
        user.verification_otp !== String(otp)
      ) {
        return res.status(400).json({
          message: 'Invalid OTP.'
        });
      }

      if (
        !user.otp_expires_at ||
        new Date(user.otp_expires_at).getTime() < Date.now()
      ) {
        return res.status(400).json({
          message: 'OTP has expired. Please register again.'
        });
      }

      db.query(
        `UPDATE users
         SET is_verified = 1,
             verification_otp = NULL,
             otp_expires_at = NULL
         WHERE id = ?`,
        [user.id],
        (updateErr) => {
          if (updateErr) {
            console.error(updateErr);
            return res.status(500).json({
              message: 'Could not verify account.'
            });
          }

          const token = jwt.sign(
            {
              id: user.id,
              email: user.email
            },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
          );

          return res.status(200).json({
            message: 'Email verified successfully!',
            token: token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email
            }
          });
        }
      );
    }
  );
});
// Login user
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({
      message: 'Email and password are required.'
    });
  }

  db.query(
    'SELECT id, name, email, password, is_verified FROM users WHERE email = ?',
    [email],
    async (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({
          message: 'Database error.'
        });
      }

      if (results.length === 0) {
        return res.status(401).json({
          message: 'Invalid email or password.'
        });
      }

      const user = results[0];

      try {
        const passwordMatch = await bcrypt.compare(
          password,
          user.password
        );

        if (!passwordMatch) {
          return res.status(401).json({
            message: 'Invalid email or password.'
          });
        }

        if (!user.is_verified) {
          return res.status(403).json({
            message: 'Please verify your email first.'
          });
        }

        const token = jwt.sign(
          {
            id: user.id,
            email: user.email
          },
          process.env.JWT_SECRET,
          { expiresIn: '24h' }
        );

        return res.status(200).json({
          message: 'Login successful!',
          token: token,
          user: {
            id: user.id,
            name: user.name,
            email: user.email
          }
        });

      } catch (error) {
        console.error(error);
        return res.status(500).json({
          message: 'Login failed.'
        });
      }
    }
  );
});
app.listen(PORT, () => {
console.log('Bookloop backend running on http://localhost:' + PORT);
});