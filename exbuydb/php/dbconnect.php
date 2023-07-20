<?php
$servername = "localhost";
$username   = "berhadco_jenn";
$password   = "JennPersonal@2023";
$dbname     = "berhadco_jenn";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>