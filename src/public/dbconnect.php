<?php

$dbuser = 'root';
$dbpass = getenv('MYSQL_ENV_MYSQL_ROOT_PASSWORD');
$dbhost = 'mysql';
$dbname = 'sample';

$dsn = "mysql:host=$dbhost;dbname=$dbname;charset=utf8";

try {
    $pdo = new PDO($dsn, $dbuser, $dbpass);
} catch (PDOException $e) {
    exit('DB接続失敗。'.$e->getMessage());
}

$stmt = $pdo->query('SELECT * FROM users');

print '<table border="1">';
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    print "<tr><td>{$row['id']}</td><td>{$row['name']}</td></tr>";
}
print '</table>';
