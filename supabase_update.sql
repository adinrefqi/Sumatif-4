-- =====================================================
-- UPDATE SCHEMA SUPABASE - SUMATIF 4 SMP THHK (FULL UPDATE 11 MEI 2026)
-- =====================================================

-- 1. TABEL: LAPORAN SELESAI
CREATE TABLE IF NOT EXISTS public.laporan_selesai (
    id              BIGSERIAL PRIMARY KEY,
    nama_siswa      TEXT,
    kelas           TEXT,
    ruangan         TEXT,
    jam_selesai     TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.laporan_selesai ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public insert" ON public.laporan_selesai FOR INSERT WITH CHECK (true);
CREATE POLICY "Allow public read" ON public.laporan_selesai FOR SELECT USING (true);

-- 2. TABEL: MASTER DATA SISWA
CREATE TABLE IF NOT EXISTS public.master_siswa (
    id              TEXT PRIMARY KEY,
    nama            TEXT,
    gender          TEXT,
    grade           INTEGER,
    room            INTEGER,
    religion        TEXT,
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.master_siswa ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read" ON public.master_siswa FOR SELECT USING (true);

-- 3. TABEL: MASTER DATA GURU (Baru)
CREATE TABLE IF NOT EXISTS public.master_guru (
    id              TEXT PRIMARY KEY, -- ID Login Guru
    nama            TEXT,
    role            TEXT DEFAULT 'guru',
    created_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.master_guru ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public read guru" ON public.master_guru FOR SELECT USING (true);

-- 4. TABEL: PRESENSI SISWA (Pusat Data Kehadiran & Metadata Sesi)
CREATE TABLE IF NOT EXISTS public.presensi_siswa (
    id                  BIGSERIAL PRIMARY KEY,
    mata_pelajaran      TEXT,
    tanggal             TEXT,
    ruang               TEXT, -- Bisa berisi nama ruang (R1) atau 'SESSION_METADATA'
    data_siswa          JSONB, -- Untuk menyimpan {nama, nomor, ttd}
    pukul               TEXT,
    pengawas_1_nama     TEXT,
    pengawas_1_niy      TEXT,
    pengawas_2_nama     TEXT,
    pengawas_2_niy      TEXT,
    p1_ttd              TEXT, -- Base64 TTD Pengawas
    p2_ttd              TEXT, -- Base64 TTD Pengawas
    created_at          TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.presensi_siswa ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow all access" ON public.presensi_siswa FOR ALL USING (true);

-- 5. TABEL: BERITA ACARA GURU
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
ALTER TABLE public.berita_acara_guru ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all" ON public.berita_acara_guru FOR ALL USING (true);

-- 6. TABEL: EXAM SETTINGS (Untuk Panel Kurikulum)
CREATE TABLE IF NOT EXISTS public.exam_settings (
    id              TEXT PRIMARY KEY,
    data            JSONB,
    updated_at      TIMESTAMPTZ DEFAULT NOW()
);
ALTER TABLE public.exam_settings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Allow public all settings" ON public.exam_settings FOR ALL USING (true);
