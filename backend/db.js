const mysql = require('mysql2');

const db = mysql.createConnection({
host: 'localhost',
user: 'root',
password: '@Afrin123',
database: 'bookloop_db'
});

db.connect((err) => {
if (err) {
console.log('Database connection failed!');
console.log(err);
} else {
console.log('BookLoop database connected successfully!');
}
});

module.exports = db;