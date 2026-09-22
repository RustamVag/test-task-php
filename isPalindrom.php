<?php

function palindrome(string $string, string $encoding = 'UTF-8'): bool
{
	$string = preg_replace('/[^\p{L}\p{N}]+/u', '', $string);

    $string = mb_strtolower($string, $encoding);

    $len = mb_strlen($string, $encoding);
    for ($i = 0, $j = $len - 1; $i < $j; $i++, $j--) {
        if (mb_substr($string, $i, 1, $encoding) !== mb_substr($string, $j, 1, $encoding)) {
            return false;
        }
    }
    return true;
}


// Тест кейсы
$texts = [
	'шалаш',
	'Анна',
	'12344321',
	'п',
	'',
	'привет',
	' Анна',
	' шалаш',
	' шалаши',
];

foreach ($texts as $text) {
	echo "\nСлово '$text' - ". (palindrome($text) ? "палиндром" : "не палиндром");
}