ToeyMusic Jukebox 80s — คู่มือติดตั้ง Backend (Supabase)
======================================================

สิ่งที่รวมในชุดนี้
- index.html: หน้าเว็บเดิม คงธีม Neon 80s และเมนูหลัก
- assets/: ภาพเดิม + โลโก้ ToeyMusic + favicon
- supabase-config.js: จุดใส่ Project URL และ Publishable/anon key
- supabase-setup.sql: สร้างตาราง, bucket และ RLS policies

สถาปัตยกรรม
- ผู้เข้าชมทั่วไป: อ่านรายการเพลง/โฟลเดอร์ และสตรีมไฟล์เสียงได้โดยไม่ต้องสมัครสมาชิก
- ผู้ดูแล: ต้องล็อกอินด้วยอีเมล/รหัสผ่าน จึงอัปโหลด แก้ไข ลบเพลง และจัดการโฟลเดอร์ได้
- เพลงและโฟลเดอร์: เก็บส่วนกลางบน Supabase
- เพลย์ลิสต์และรายการโปรด: ยังคงเก็บในเบราว์เซอร์ของผู้ใช้แต่ละคนในเวอร์ชันนี้
- ถ้าไม่ใส่ค่า Supabase เว็บไซต์จะยังเปิดเป็นโหมดทดลองในเครื่อง (IndexedDB) เหมือนเดิม

ติดตั้ง Supabase
1. ไปที่ https://supabase.com/ แล้วสร้าง Project ใหม่ ตั้งชื่อ ToeyMusic และเลือก Region ที่ใกล้ประเทศไทยที่สุดที่มีให้เลือก
2. รอให้ Project พร้อม แล้วเปิด SQL Editor > New query
3. เปิดไฟล์ supabase-setup.sql คัดลอกทั้งหมดไปวาง แล้วกด Run
4. ไปที่ Authentication > Users แล้วสร้างผู้ใช้ผู้ดูแลด้วยอีเมลของคุณ (หรือสมัครผ่านระบบ Auth ก่อน แล้วกลับมาตรวจสอบ Users)
5. คัดลอก User UID ของผู้ดูแลจากหน้า Users
6. กลับไป SQL Editor แล้วรันคำสั่งนี้ โดยแทน UUID ด้วย User UID จริง:
   insert into public.admin_users (user_id) values ('ใส่-USER-UUID-ตรงนี้');
7. ไปที่ Project Settings > API แล้วคัดลอก Project URL และ Publishable key (หรือ anon public key แบบเก่า)
8. เปิด supabase-config.js แล้วแทนข้อความตัวอย่างด้วยค่าจริง เช่น:
   window.TOEYMUSIC_SUPABASE = {
     url: "https://YOUR-PROJECT.supabase.co",
     anonKey: "YOUR-PUBLISHABLE-OR-ANON-KEY"
   };
   ห้ามใส่ service_role key หรือ secret key ในไฟล์หน้าเว็บเด็ดขาด
9. อัปโหลดไฟล์ทั้งหมดใน ZIP ไปยังโฟลเดอร์เว็บไซต์ (เช่น public_html) โดยคงโฟลเดอร์ assets และไฟล์ JS/SQL ไว้คู่กับ index.html
10. เปิดเว็บไซต์ด้วย HTTPS แล้วทดสอบปุ่มเข้าสู่ระบบผู้ดูแล อัปโหลดเพลง และเปิดฟังจากโทรศัพท์อีกเครื่อง

การใช้งาน
- ทุกคนเข้าเว็บไซต์และฟังเพลงได้โดยไม่ต้องล็อกอิน
- ผู้ดูแลกด “เข้าสู่ระบบผู้ดูแล” แล้วกรอกอีเมล/รหัสผ่านที่สร้างไว้ใน Supabase
- เมื่อเป็นผู้ดูแล ปุ่มเพิ่มเพลงและจัดการโฟลเดอร์จะแสดงขึ้น
- แนะนำ MP3; bucket นี้อนุญาต MP3, M4A/MP4, AAC, WAV, OGG, FLAC และ WebM audio
- จำกัดขนาดไฟล์ต่อเพลงไว้ 50 MB ตามการตั้งค่าเริ่มต้นของ bucket

สำคัญเรื่อง Hosting
ไฟล์ ZIP เพียงอย่างเดียวบอกไม่ได้ว่าเว็บไซต์ปัจจุบันฝากไว้กับผู้ให้บริการใด และไม่มี URL หรือข้อมูลเข้าระบบ Hosting แนบมา จึงยังตรวจสอบ/อัปโหลดขึ้นเว็บไซต์จริงแทนไม่ได้ หากส่ง URL เว็บไซต์ปัจจุบัน หรือภาพหน้า Hosting/cPanel (ปิดบังรหัสผ่านและข้อมูลลับ) จะช่วยระบุวิธีนำไฟล์ขึ้นระบบได้

ข้อจำกัดของเวอร์ชันนี้
- ยังไม่ได้เชื่อมบัญชี Supabase จริง เพราะต้องให้เจ้าของบัญชีสร้าง Project และส่งเฉพาะ Project URL + Publishable/anon key ที่เป็น public key มาใส่ config (ห้ามส่งรหัสผ่านหรือ service_role key)
- เพลงเดิมที่เคยเพิ่มไว้ใน IndexedDB ของเบราว์เซอร์จะไม่ถูกย้ายขึ้น Cloud อัตโนมัติ ต้องอัปโหลดไฟล์ต้นฉบับเข้าใหม่
- เพลย์ลิสต์และรายการโปรดเป็นข้อมูลเฉพาะเบราว์เซอร์ ยังไม่ sync ข้ามอุปกรณ์
- ควรใช้เฉพาะเพลงที่มีสิทธิ์จัดเก็บและเผยแพร่/สตรีมต่อสาธารณะ


สถานะการเชื่อมต่อสำหรับโปรเจกต์ของเจ้าของเว็บไซต์
-------------------------------------------------
- ใส่ Project URL และ Publishable Key ที่ได้รับลงใน supabase-config.js แล้ว
- ยังไม่สามารถสร้างตารางหรือ Bucket ภายในบัญชี Supabase แทนเจ้าของบัญชีได้จากไฟล์เว็บไซต์
- ขั้นตอนที่ยังต้องทำใน Dashboard:
  1) เปิด SQL Editor ของโปรเจกต์ qlwqzfnwtztosxbglghz
  2) รันไฟล์ supabase-setup.sql ทั้งหมดหนึ่งครั้ง
  3) ไปที่ Authentication > Users แล้วสร้างบัญชีผู้ดูแล (อีเมล/รหัสผ่าน)
  4) คัดลอก User UID แล้วรันคำสั่ง INSERT ที่ระบุในคู่มือ เพื่อมอบสิทธิ์ Admin
  5) ตั้ง Authentication > URL Configuration ให้ Site URL เป็น https://hrangchao-ui.github.io
     และเพิ่ม Redirect URL https://hrangchao-ui.github.io/JukeboxToey/
  6) อัปโหลดไฟล์ทั้งหมดในโฟลเดอร์นี้ไปยัง GitHub repository JukeboxToey แล้ว Commit/Push

หมายเหตุ: Publishable Key ใช้ในหน้าเว็บได้ตามวัตถุประสงค์ของ Supabase แต่สิทธิ์จริงถูกควบคุมด้วย RLS policies ใน SQL
ห้ามใส่ Secret Key หรือ service_role key ลงในเว็บไซต์หรือ GitHub repository
