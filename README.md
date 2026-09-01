# Kantin Multi-Tenant
 
Aplikasi kantin multi-tenant berbasis Laravel 13 dengan starter kit Livewire 4, MariaDB sebagai penyimpanan data transaksional, dan Redis untuk cache, session, cart, serta queue. Fitur realtime menggunakan Laravel Reverb.
 
## Requirements
 
Pastikan versi tool berikut terpasang sebelum memulai:
 
| Tool | Versi Minimum | Catatan |
|---|---|---|
| PHP | 8.3+ | Wajib untuk Laravel 13 |
| Composer | Terbaru | Pengelola dependency PHP |
| Node.js & NPM | Terbaru (LTS disarankan) | Untuk build aset frontend (Vite) |
| Git | Terbaru | Version control |
| MariaDB | Terbaru | Data transaksional |
| Redis | Terbaru | Cache, session, cart, queue |
 
Ekstensi PHP yang wajib aktif:
 
- `pdo_mysql`
- `mbstring`
- `openssl`
- `ctype`
- `curl`
- `fileinfo`
- `xml`
- `tokenizer`
- `redis` (phpredis)
 
Cek kesiapan environment:
 
```bash
php -v
composer --version
node -v
npm -v
git --version
php -m | grep redis
```
 
## Setup
 
### 1. Clone repository
 
```bash
git clone https://github.com/fernando0707-droi/kantin-multi-tenant.git
cd kantin-multi-tenant
```
 
### 2. Install dependency
 
```bash
composer install
npm install
```
 
### 3. Konfigurasi environment
 
Salin `.env.example` menjadi `.env`, lalu generate application key:
 
```bash
cp .env.example .env
php artisan key:generate
```
 
> **Windows (PowerShell):** gunakan `Copy-Item .env.example .env` bila `cp` tidak dikenali.
 
Isi variabel berikut di `.env`:
 
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=kantin_multi_tenant
DB_USERNAME=root
DB_PASSWORD=
 
CACHE_STORE=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
 
REDIS_CLIENT=phpredis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
 
BROADCAST_CONNECTION=reverb
REVERB_APP_ID=
REVERB_APP_KEY=
REVERB_APP_SECRET=
REVERB_HOST="localhost"
REVERB_PORT=8080
REVERB_SCHEME=http
 
VITE_REVERB_APP_KEY="${REVERB_APP_KEY}"
VITE_REVERB_HOST="${REVERB_HOST}"
VITE_REVERB_PORT="${REVERB_PORT}"
VITE_REVERB_SCHEME="${REVERB_SCHEME}"
```
 
Jangan lupa buat database terpisah untuk testing (misalnya `kantin_multi_tenant_test`) agar `migrate:fresh` tidak menyentuh data pengembangan.
 
### 4. Install Livewire & Reverb (jika belum terpasang)
 
```bash
composer require livewire/livewire:^4.0
composer require laravel/reverb -W
php artisan install:broadcasting
```
 
Flag `-W` (`--with-all-dependencies`) diperlukan agar Composer bisa menyesuaikan versi dependency terkait seperti `guzzlehttp/psr7`.
 
### 5. Jalankan migrasi
 
```bash
php artisan migrate:fresh --seed
```
 
### 6. Build aset frontend
 
```bash
npm run build
```
 
## Run
 
Jalankan seluruh proses pengembangan (server, queue worker, Vite) sekaligus:
 
```bash
composer run dev
```
 
Kalau proses Reverb tidak ikut terpasang di script `dev`, jalankan di terminal terpisah:
 
```bash
php artisan reverb:start
```
 
Aplikasi dapat diakses di `http://localhost:8000`.
 
### Cek koneksi layanan
 
```bash
php artisan db:show
redis-cli -p 6379 ping
```
 
`redis-cli` harus membalas `PONG`. Kalau `redis-cli` tidak dikenali di terminal (umum terjadi di Windows/ServBay), cukup verifikasi lewat Laravel:
 
```bash
php artisan tinker
```
```php
Cache::put('test', 'halo redis', 60);
Cache::get('test');
```
 
## Test
 
Jalankan test suite:
 
```bash
php artisan test
```
 
Format kode dengan Pint:
 
```bash
php vendor/bin/pint --test   # cek saja, tanpa mengubah file
php vendor/bin/pint          # auto-fix
```
 
Build ulang aset dan pastikan tidak ada error:
 
```bash
npm run build
```
 
Pastikan tidak ada secret yang ikut ter-track sebelum commit:
 
```bash
git status
git diff --cached
```
 
## Troubleshooting
 
| Gejala | Kemungkinan Penyebab | Solusi |
|---|---|---|
| `connection refused` | Service (MariaDB/Redis) belum aktif atau port salah | Cek service berjalan, cocokkan `DB_PORT`/`REDIS_PORT` di `.env` |
| `access denied` | Credential database/Redis salah | Cek `DB_USERNAME`, `DB_PASSWORD`, `REDIS_PASSWORD` |
| `Class not found` | Dependency belum ter-install / autoload belum di-generate | `composer install`, lalu `composer dump-autoload` |
| Halaman terbuka tanpa styling | Vite gagal build aset | Jalankan `npm run build` ulang dan cek error di terminal |
| `Pusher\Pusher::__construct(): Argument #1 ($auth_key) must be of type string, null given` | `REVERB_APP_KEY`/`REVERB_APP_ID`/`REVERB_APP_SECRET` kosong di `.env` | Isi manual atau jalankan ulang `php artisan install:broadcasting`, lalu `php artisan config:clear` |
| Composer gagal karena konflik versi dependency | Package terkunci di versi yang tidak kompatibel | Tambahkan flag `-W` (`--with-all-dependencies`) pada `composer require` |
| `redis-cli` tidak dikenali di terminal (Windows) | Binary tidak masuk PATH sistem | Verifikasi Redis lewat `php artisan tinker` alih-alih `redis-cli`, atau tambahkan folder binary ke PATH |
| `./vendor/bin/...` tidak dikenali di PowerShell | Sintaks path Unix tidak berlaku di PowerShell | Gunakan `php vendor\bin\nama-tool` atau `.\vendor\bin\nama-tool` |
| `.env` ikut ter-track di Git | `.gitignore` belum menyertakan `.env` atau file sudah pernah di-commit sebelumnya | Tambahkan `.env` ke `.gitignore`, lalu `git rm --cached .env` bila sudah terlanjur ter-track |
| `fatal: not a git repository` | Folder belum di-init sebagai repo Git | Jalankan `git init` di root project |
 
### Diagnosis umum
 
1. Identifikasi proses mana yang gagal: HTTP server, queue worker, atau Vite — masing-masing berjalan terpisah lewat `composer run dev`.
2. Baca log proses yang gagal terlebih dahulu sebelum menelusuri bagian lain.
3. Bedakan gangguan aplikasi (kode/konfigurasi Laravel) dari gangguan infrastruktur lokal (service belum jalan, port bentrok, PATH sistem).
