# Godot PVZ Beta

Dokumentasi singkat untuk instalasi dan menjalankan project ini setelah di-clone.

## Persyaratan

- [Git](https://git-scm.com/downloads)
- [Godot Engine 4.7](https://godotengine.org/download) (sesuai `config/features` di `project.godot`)

## Cara Install (Clone Project)

1. Buka terminal.
2. Clone repository:

   ```bash
   git clone https://github.com/syarifyahyash/godot-pvz-beta.git
   ```

3. Masuk ke folder project:

   ```bash
   cd godot-pvz-beta
   ```

## Cara Menjalankan Project

### Opsi 1 (Lewat Godot Editor)

1. Buka Godot Engine.
2. Pilih **Import**.
3. Arahkan ke file `project.godot` di folder `godot-pvz-beta`.
4. Klik **Import & Edit**.
5. Jalankan project dengan tombol **Play** (atau tekan `F5`).

### Opsi 2 (Lewat Command Line)

Jalankan dari root project:

```bash
godot --path .
```

## Catatan

- Scene utama project sudah diatur di `project.godot` (`run/main_scene`).
- Jika project tidak bisa dibuka, pastikan versi Godot yang dipakai sesuai (4.7).
