#!/bin/bash
set -e

echo "=== 1. Papka va fayllarni tayyorlash ==="
mkdir -p /var/www/polynor
cd /var/www/polynor

# Eski fayllarni tozalab, GitHub-dan eng yangisini yuklash
rm -rf *
git clone https://github.com/Dariko-HR-Marketing/Polynor.git .

# Agar fayl nomi o'zgarmagan bo'lsa, avtomatik index.html qilish
if [ -f "POLYNOR — продукция и решения.html" ]; then
    mv "POLYNOR — продукция и решения.html" index.html
fi

# Ruxsatlarni to'g'rilash
chown -R www-data:www-data /var/www/polynor
chmod -R 755 /var/www/polynor

echo "=== 2. Caddy Web Serverni sozlash ==="
cat << 'EOF' > /etc/caddy/Caddyfile
polynor.tajriba24.uz {
    root * /var/www/polynor
    file_server
    try_files {path} /index.html
}
EOF

echo "=== 3. Caddy-ni qayta ishga tushirish ==="
systemctl reload caddy

echo "=== TAYYOR! https://polynor.tajriba24.uz muvaffaqiyatli ishga tushdi ==="
