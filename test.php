<?php
if((!isset($_COOKIE['licznikowe-ciacho'])) && (!strstr($_SERVER['HTTP_REFERER'], "strona.pl"))) {
$plik = fopen("licznik.txt", "r");
$tekst = fread($plik, filesize("licznik.txt"));
$dane = explode(";", $tekst);
fclose($plik);
$plik = fopen("licznik.txt", "w");
flock($plik, 2);
$dane[0]++;
fwrite($plik, "$dane[0];", 15);
flock($plik, 3);
fclose($plik);
setcookie("licznikowe-ciacho", "zliczono", 0);
}
else {
$plik = fopen("licznik.txt", "r");
$tekst = fread($plik, filesize("licznik.txt"));
$dane = explode(";", $tekst);
}

?>
