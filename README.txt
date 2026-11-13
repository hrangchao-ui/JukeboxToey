ToeyMusic — Jukebox 80s (Backend-ready package)
================================================

เริ่มต้นใช้งานแบบเว็บไซต์เดิม
1. แตก ZIP
2. เปิด index.html ผ่าน Chrome/Edge หรืออัปโหลดทั้งชุดขึ้น Web Hosting
3. ถ้ายังไม่ตั้งค่า Supabase เว็บไซต์จะทำงานเป็นโหมดทดลองในเครื่อง (IndexedDB)

เปิดใช้งานคลังเพลงส่วนกลาง
1. อ่าน README_BACKEND_TH.txt อย่างละเอียด
2. สร้าง Supabase Project
3. รัน supabase-setup.sql ใน Supabase SQL Editor
4. สร้างบัญชีผู้ดูแลและเพิ่ม User UID ในตาราง admin_users ตามคู่มือ
5. ใส่ Project URL และ Publishable/anon key ใน supabase-config.js
6. อัปโหลดไฟล์ทั้งหมดไปยัง Hosting โดยคง assets/ ไว้คู่กับ index.html

ไฟล์สำคัญ
- index.html: เว็บไซต์ธีม Neon 80s พร้อมเชื่อม Backend
- assets/: ภาพประกอบ โลโก้ ToeyMusic และ favicon
- supabase-config.js: ค่าตั้งค่า Project (ต้องใส่ URL และ public key ของโปรเจกต์จริง)
- supabase-setup.sql: schema, storage bucket และ Row Level Security policies
- README_BACKEND_TH.txt: คู่มือติดตั้งภาษาไทย

สิทธิ์การใช้งาน
- ผู้เข้าชมทุกคน: ดูคลังเพลงและฟังเพลงได้โดยไม่ต้องสมัครสมาชิก
- ผู้ดูแลที่ได้รับอนุญาต: เพิ่ม/แก้ไข/ลบเพลง และจัดการโฟลเดอร์
- เพลย์ลิสต์และรายการโปรด: เก็บเฉพาะเบราว์เซอร์ในเวอร์ชันนี้ ยังไม่ sync ข้ามอุปกรณ์

ข้อจำกัด/ข้อควรระวัง
- ยังไม่ได้เชื่อม Supabase Project จริง เนื่องจากต้องสร้าง Project ในบัญชีของเจ้าของเว็บไซต์ก่อน
- ห้ามใส่ service_role key หรือ secret key ในไฟล์หน้าเว็บ ใช้เฉพาะ Publishable/anon key
- จำกัดไฟล์เสียงต่อไฟล์ 50 MB ตามค่าเริ่มต้นของ bucket
- เพลงที่เคยอยู่ใน IndexedDB จะไม่ถูกย้ายขึ้น Cloud โดยอัตโนมัติ ต้องอัปโหลดไฟล์ต้นฉบับใหม่
- ใช้เฉพาะเพลงที่มีสิทธิ์จัดเก็บและเผยแพร่/สตรีมต่อสาธารณะ
- ไฟล์ ZIP ไม่มีข้อมูลระบุผู้ให้บริการ Hosting หรือ URL เว็บไซต์จริง จึงยังตรวจสอบ Hosting เดิมไม่ได้
