UPDATE t_meal
SET image_blur_hash = 'LEHLh[WB2yk8pyoJadR*.7kCMdnj'
WHERE image_url IS NOT NULL
    AND image_url <> '';
