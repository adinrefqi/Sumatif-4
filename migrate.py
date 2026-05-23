import re

with open('index.html', 'r', encoding='utf-8') as f:
    idx_content = f.read()

with open('dashboard_pengawas.html', 'r', encoding='utf-8') as f:
    db_content = f.read()

# 1. Extract Modals
ba_modal = re.search(r'(<!-- ========== MODAL BERITA ACARA GURU ========== -->.*?</div>\s*</div>)', idx_content, re.DOTALL).group(1)
riwayat_modal = re.search(r'(<!-- ========== MODAL RIWAYAT KEHADIRAN ========== -->.*?</div>\s*</div>)', idx_content, re.DOTALL).group(1)
kurikulum_modal = re.search(r'(<!-- MODAL CONTROL PANEL KURIKULUM -->.*?</div>\s*</div>\s*</div>)', idx_content, re.DOTALL).group(1)

# Combine modals
all_modals = f"\n\n{ba_modal}\n\n{riwayat_modal}\n\n{kurikulum_modal}\n\n"

# Insert modals into dashboard before <style>
db_content = db_content.replace('    <style>', f'{all_modals}    <style>')

# 2. Extract JS Functions
js_functions = [
    r'(function openModal.*?})',
    r'(function closeModal.*?})',
    r'(// Fungsi Inisialisasi Signature Pad.*?function clearSig.*?})',
    r'(function printBAForm.*?})',
    r'(async function submitBADoc.*?})',
    r'(// Fungsi Load Riwayat Global.*?async function loadRiwayatGlobal.*?})',
    r'(// Fungsi Format Tanggal.*?function formatTanggal.*?})',
    r'(function switchRiwayatTab.*?})',
    r'(async function loadRiwayatBA.*?})',
    r'(async function deleteBA.*?})',
    r'(async function printRiwayatBA.*?})',
    r'(window\.printRiwayatBA\s*=\s*.*?};)',
    r'(function authKurikulum.*?})',
    r'(async function setGlobalStatus.*?})',
    r'(async function setMapelStatus.*?})',
    r'(async function setControlGrade.*?})',
    r'(function renderSubjectControls.*?})',
    r'(function searchMasterStudent.*?})',
    r'(function syncControlToSupabase.*?})',
    r'(function fillBAForm.*?})',
    r'(function cetakRiwayatHarian.*?})',
    r'(function cetakSemuaHarian.*?})'
]

extracted_js = []
for pattern in js_functions:
    matches = re.finditer(pattern, idx_content, re.DOTALL)
    for m in matches:
        extracted_js.append(m.group(1))

# We need to make sure we get the full functions. Some functions might have nested braces.
# It's safer to extract blocks by line numbers or using a more robust parser.
