<?php
//error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$phone = $_GET['phone'];
$amount = $_GET['amount'];
$email = $_GET['email'];
$name = $_GET['name'];

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 
$signed= hash_hmac('sha256', $signing, 'S-oNqPle-9aOTFiEnw_WTwiA');
if ($signed === $data['x_signature']) {
    if ($paidstatus == "Success"){ //payment success
         $sqlcart = "SELECT * FROM `tbl_carts` WHERE user_id = '$userid' ORDER BY seller_id ASC";
        $result = $conn->query($sqlcart);
        $seller = "";
        $singleorder = 0;
        $i =0;
        $numofrows = $result->num_rows;
        if ($result->num_rows > 0) {
            while ($row = $result->fetch_assoc()) {
                $seller_id = $row['seller_id'];
                $catchid = $row['catch_id'];
                $orderqty = $row['cart_qty'];
                $order_paid = $row['cart_price'];
                
                if ($i==0){
                    $seller = $seller_id;
                }
                
                if ($seller == $seller_id){
                    $singleorder = $singleorder + $order_paid;    
                }else{
                    $sqlorder ="INSERT INTO `tbl_orders`( `order_bill`, `order_paid`, `buyer_id`, `seller_id`, `order_status`) VALUES ('$receiptid','$singleorder','$userid','$seller','New')";
                    $conn->query($sqlorder);
                    $seller = $seller_id;
                    $singleorder = $order_paid;
                }
                
                if ($i == ($numofrows-1)){
                     $singleorder = $singleorder; 
                    $sqlorder ="INSERT INTO `tbl_orders`( `order_bill`, `order_paid`, `buyer_id`, `seller_id`, `order_status`) VALUES ('$receiptid','$singleorder','$userid','$seller','New')";
                    $conn->query($sqlorder);
                }
                $i++;
                
                $sqlorderdetails = "INSERT INTO `tbl_orderdetails`(`order_bill`, `catch_id`, `orderdetail_qty`, `orderdetail_paid`, `buyer_id`, `seller_id`) VALUES ('$receiptid','$catchid','$orderqty','$order_paid','$userid','$seller_id')";
                $conn->query($sqlorderdetails);
                $sqlupdatecatchqty = "UPDATE `tbl_catches` SET `catch_qty`= (catch_qty - $orderqty) WHERE `catch_id` = '$catchid'";
                $conn->query($sqlupdatecatchqty);
            }
            $sqldeletecart = "DELETE FROM `tbl_carts` WHERE user_id = '$userid'";
            $conn->query($sqldeletecart);
        }
        
        echo '
<html>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="resit.css">
    <body>
        <div class="table-container">
        <center><h4>Receipt</h4></center>
        <table>
            <tr class="table-header">
                <th>Item</th>
                <th>Description</th>
            </tr>
            <tr>
                <td>Name</td>
                <td>'.$name.'</td>
            </tr>
            <tr>
                <td>Email</td>
                <td>'.$email.'</td>
            </tr>
            <tr>
                <td>Phone</td>
                <td>'.$phone.'</td>
            </tr>
            <tr>
                <td>Paid Amount</td>
                <td>RM'.$amount.'</td>
            </tr>
            <tr>
                <td>Paid Status</td>
                <td class="paid-status">'.$paidstatus.'</td>
            </tr>
        </table><br>
        </div>
    </body>
</html>';
    }
    else 
    {
        echo '
        <html>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <link rel="stylesheet" href="resit.css">
            <body>
                <div class="table-container">
                <center><h4>Receipt</h4></center>
                <table>
                    <tr class="table-header">
                        <th>Item</th>
                        <th>Description</th>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>'.$name.'</td>
                    </tr>
                    <tr>
                        <td>Email</td>
                        <td>'.$email.'</td>
                    </tr>
                    <tr>
                        <td>Phone</td>
                        <td>'.$phone.'</td>
                    </tr>
                    <tr>
                        <td>Paid Amount</td>
                        <td>RM'.$amount.'</td>
                    </tr>
                    <tr>
                        <td>Paid Status</td>
                        <td class="paid-status">'.$paidstatus.'</td>
                    </tr>
                </table><br>
                </div>
            </body>
        </html>';        
    }
}

?>