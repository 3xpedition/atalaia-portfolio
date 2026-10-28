<?php

declare(strict_types=1);

$mediaDirectory = dirname(__DIR__) . '/docs/assets/media';
$files = glob($mediaDirectory . '/*.png') ?: [];

foreach ($files as $source) {
    $image = imagecreatefrompng($source);
    if ($image === false) {
        fwrite(STDERR, "Não foi possível abrir {$source}.\n");
        exit(1);
    }

    imagepalettetotruecolor($image);
    imagealphablending($image, true);
    imagesavealpha($image, true);

    $base = substr($source, 0, -4);
    if (!imagewebp($image, $base . '.webp', 82)) {
        fwrite(STDERR, "Falha ao gerar WebP para {$source}.\n");
        exit(1);
    }

    if (!imageavif($image, $base . '.avif', 58, 6)) {
        fwrite(STDERR, "Falha ao gerar AVIF para {$source}.\n");
        exit(1);
    }

    echo basename($source) . " otimizada.\n";
}
