-- =====================================================
-- SCHEMA SUPABASE - SUMATIF 4 SMP THHK (VERSI LENGKAP)
-- Jalankan di Supabase SQL Editor:
-- =====================================================

-- 1. TABEL: DAFTAR HADIR SISWA
CREATE TABLE IF NOT EXISTS public.presensi_siswa (
    id              BIGSERIAL PRIMARY KEY,
    mata_pelajaran  TEXT,
    tanggal         TEXT,
    ruang           TEXT,
    pukul           TEXT,
    pengawas_1_nama TEXT,
    pengawas_1_niy  TEXT,
    pengawas_2_nama TEXT,
    pengawas_2_niy  TEXT,
    data_siswa      JSONB,      -- objek/array: {no, nomor_peserta, nama, ttd}
    p1_ttd          TEXT,      -- signature pengawas 1
    p2_ttd          TEXT,      -- signature pengawas 2
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABEL: BERITA ACARA GURU
CREATE TABLE IF NOT EXISTS public.berita_acara_guru (
    id                  BIGSERIAL PRIMARY KEY,
    mata_pelajaran      TEXT,
    hari                TEXT,
    tanggal             TEXT,
    bulan               TEXT,
    tahun               TEXT,
    pukul_mulai         TEXT,
    pukul_selesai       TEXT,
    lokasi              TEXT,
    ruang               TEXT,
    jumlah_seharusnya   TEXT,
    jumlah_hadir        TEXT,
    nomor_hadir         TEXT,
    jumlah_tidak_hadir  TEXT,
    nomor_tidak_hadir   TEXT,
    lembar_soal         TEXT,
    lembar_ba           TEXT,
    lembar_jawab        TEXT,
    catatan             TEXT,
    pengawas_1_nama     TEXT,
    pengawas_1_niy      TEXT,
    pengawas_2_nama     TEXT,
    pengawas_2_niy      TEXT,
    p1_ttd              TEXT,
    p2_ttd              TEXT,
    created_at          TIMESTAMPTZ DEFAULT NOW()
);

-- 3. TABEL: LAPORAN SELESAI (Monitoring Selesai Ujian)
CREATE TABLE IF NOT EXISTS public.laporan_selesai (
    id              BIGSERIAL PRIMARY KEY,
    nama_siswa      TEXT,
    kelas           TEXT,
    ruangan         TEXT,
    jam_selesai     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- 4. TABEL: MASTER DATA SISWA
CREATE TABLE IF NOT EXISTS public.master_siswa (
    id              TEXT PRIMARY KEY, -- Nomor Peserta
    nama            TEXT,
    gender          TEXT,
    grade           INTEGER,
    room            INTEGER,
    religion        TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

-- =====================================================
-- ROW LEVEL SECURITY (RLS) - PUBLIC ACCESS
-- =====================================================

ALTER TABLE public.presensi_siswa ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all" ON public.presensi_siswa FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE public.berita_acara_guru ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all" ON public.berita_acara_guru FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE public.laporan_selesai ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all" ON public.laporan_selesai FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE public.master_siswa ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.master_siswa FOR SELECT USING (true);

-- =====================================================
-- IMPORT DATA SISWA (52 SISWA)
-- =====================================================
INSERT INTO public.master_siswa (id, nama, gender, grade, room, religion) VALUES 
('2026-0303-0001', 'Anceline Sharon Susanto', 'Perempuan', 9, 1, 'Kristen'),
('2026-0303-0002', 'Andica Jose Wirokusumo', 'Laki-laki', 9, 1, 'Katolik'),
('2026-0303-0003', 'Christian Nathanael Daniello', 'Laki-laki', 9, 1, 'Kristen'),
('2026-0303-0004', 'Doddy Saputra', 'Laki-laki', 9, 1, 'Katolik'),
('2026-0303-0005', 'Evangeline Sheron Loriensa', 'Perempuan', 9, 2, 'Kristen'),
('2026-0303-0006', 'Henri Untoro', 'Laki-laki', 9, 2, 'Katolik'),
('2026-0303-0007', 'Juanita Adeline Wijaya', 'Perempuan', 9, 2, 'Budha'),
('2026-0303-0008', 'Mathea Elite Wijaya', 'Perempuan', 9, 2, 'Katolik'),
('2026-0303-0009', 'Matthew Geraldo Soetjipto', 'Laki-laki', 9, 3, 'Katolik'),
('2026-0303-0010', 'Nauli Widi Siddhatta', 'Laki-laki', 9, 3, 'Kristen'),
('2026-0303-0011', 'Yehezkiel Joenard Christensen', 'Laki-laki', 9, 3, 'Kristen'),
('2026-0303-0012', 'Calvin Fransisco', 'Laki-laki', 8, 1, 'Konghucu'),
('2026-0303-0013', 'Celine Octavia Kusuma', 'Perempuan', 8, 1, 'Kristen'),
('2026-0303-0014', 'Clarice Siera Elisabeth Rahardjo', 'Perempuan', 8, 1, 'Katolik'),
('2026-0303-0015', 'Clement Raphael Kurnia', 'Laki-laki', 8, 1, 'Kristen'),
('2026-0303-0016', 'Darwin Adelio Alvaro', 'Laki-laki', 8, 1, 'Budha'),
('2026-0303-0017', 'Erland Adriano Budiman', 'Laki-laki', 8, 1, 'Islam'),
('2026-0303-0018', 'Faris Mahardika Luki', 'Laki-laki', 8, 1, 'Islam'),
('2026-0303-0019', 'Flourencia Alvina', 'Perempuan', 8, 1, 'Katolik'),
('2026-0303-0020', 'Giovanni Agnell Tanuwijaya', 'Laki-laki', 8, 1, 'Islam'),
('2026-0303-0021', 'Gisella Cellena Cleola Andrian', 'Perempuan', 8, 2, 'Katolik'),
('2026-0303-0022', 'Graciana Shinta Dewi', 'Perempuan', 8, 2, 'Kristen'),
('2026-0303-0023', 'Henedictus Greffy Jeisen Putra', 'Laki-laki', 8, 2, 'Budha'),
('2026-0303-0024', 'Ivana Jacinda', 'Perempuan', 8, 2, 'Budha'),
('2026-0303-0025', 'Jefferson Setiawan', 'Laki-laki', 8, 2, 'Konghucu'),
('2026-0303-0026', 'Jesslyn Anna Belle Arminta Prawiro', 'Perempuan', 8, 2, 'Katolik'),
('2026-0303-0027', 'Jesslyn Yoewono', 'Perempuan', 8, 2, 'Konghucu'),
('2026-0303-0028', 'Jocelyn Octavia Gunawan', 'Perempuan', 8, 2, 'Budha'),
('2026-0303-0029', 'Johan Faizal', 'Laki-laki', 8, 2, 'Kristen'),
('2026-0303-0030', 'Keiko Lee Yohanes', 'Perempuan', 8, 3, 'Kristen'),
('2026-0303-0031', 'Marquez Loris', 'Laki-laki', 8, 3, 'Budha'),
('2026-0303-0032', 'Michelle Angelica Setiono', 'Perempuan', 8, 3, 'Kristen'),
('2026-0303-0033', 'Mikhaela Josephine Soetjipto', 'Perempuan', 8, 3, 'Katolik'),
('2026-0303-0034', 'Octavelie Sila Kirana', 'Perempuan', 8, 3, 'Budha'),
('2026-0303-0035', 'Reynaldo Xavier Alexander Gunawan', 'Laki-laki', 8, 3, 'Budha'),
('2026-0303-0036', 'Sebastian Moses Firlandi', 'Laki-laki', 8, 3, 'Kristen'),
('2026-0303-0037', 'Yuriko Jessi Setiawan', 'Perempuan', 8, 3, 'Kristen'),
('2026-0303-0038', 'Desiani Natalia Siallagan', 'Perempuan', 8, 3, 'Kristen'),
('2026-0303-0039', 'Cathleen Hava Eliora.S', 'Perempuan', 7, 1, 'Kristen'),
('2026-0303-0040', 'Chrisna Monica Onggowarsito', 'Perempuan', 7, 1, 'Kristen'),
('2026-0303-0041', 'Eleanore Kimberly Wong', 'Perempuan', 7, 1, 'Budha'),
('2026-0303-0042', 'Engracia Sarah Chrisyabelle.S', 'Perempuan', 7, 1, 'Kristen'),
('2026-0303-0043', 'Jasson Alvaro Gunarto', 'Laki-laki', 7, 1, 'Kristen'),
('2026-0303-0044', 'Jennifer Aurelia Febriana', 'Perempuan', 7, 2, 'Kristen'),
('2026-0303-0045', 'Keane William Gunawan', 'Laki-laki', 7, 2, 'Islam'),
('2026-0303-0046', 'Kenichi Alvaro Gavriel', 'Laki-laki', 7, 2, 'Kristen'),
('2026-0303-0047', 'Keyzia El Ryansyah', 'Perempuan', 7, 2, 'Islam'),
('2026-0303-0048', 'Melvin Antan Djaya', 'Laki-laki', 7, 2, 'Katolik'),
('2026-0303-0049', 'M. Akhil Fadillah', 'Laki-laki', 7, 3, 'Islam'),
('2026-0303-0050', 'Nathasya Michelle Lee', 'Perempuan', 7, 3, 'Kristen'),
('2026-0303-0051', 'Nicholas Willson Kasuya', 'Laki-laki', 7, 3, 'Kristen'),
('2026-0303-0052', 'Vincentius Fernandez Suharto', 'Laki-laki', 7, 3, 'Kristen')
ON CONFLICT (id) DO UPDATE SET 
    nama = EXCLUDED.nama,
    gender = EXCLUDED.gender,
    grade = EXCLUDED.grade,
    room = EXCLUDED.room,
    religion = EXCLUDED.religion;
