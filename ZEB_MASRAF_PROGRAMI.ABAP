*&---------------------------------------------------------------------*
*& Report  ZEB_MASRAF_PROGRAMI
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

report  zeb_masraf_programi.

tables : zeb_msf_kullanic,zeb_msf_masraf,zeb_msf_personel,zeb_msf_sorumlu.
"program da kullanılacak tablolar

data : ok_code    like sy-ucomm,  "kullanıcının hangi butona basıldığı değeri tutan değişken
       save_code  like sy-ucomm,

       kadi   type zeb_msf_kullanic-kullaniciadi, "kullanıcı adı ve sifreler tanımlandı
       ksifre type zeb_msf_kullanic-kullanicisifre.

data : personel type zeb_msf_personel.

"çöp string
data copstring type string.

"yönetici ekranı tabstriplerin içinde subscreenlerin tanımlaması yapılacaktır.
"ve tabstrip kontrol değişkeni
data : gv_scr type sy-dynnr.

controls : tab_st type tabstrip.


data :  lv_date type sy-datum, "personel masraf giriş ekranı için
        mtarih  type zeb_msf_masraf-mtarih.   "textbox tarih ayarlaması

"personel masraf giriş verileri için input data ları tanımlandı
data :  mtutar      type zeb_msf_masraf-mtutar,
        mbirim      type zeb_msf_masraf-mbirim,
        mbelgeno    type zeb_msf_masraf-mbelgeno,
        maciklama   type zeb_msf_masraf-maciklama,
        mtur        type zeb_msf_masraf-mturu.

"masraf verilierinin tutulduğu internal tablo
data it_table type standard table of zeb_msf_masraf with header line.

"personelin masrafları sorgulaması için gerekli input dataları tanımlandı
data : mbelgeno1    type zeb_msf_masraf-mbelgeno.

"giriş ekranı sap user bilgileri
data : skullanici type string,
       starih     type string,
       ssaat      type string.

"masraf giriş ekranındaki container ve alv tanımlamaları.
data : go_container1 type ref to cl_gui_custom_container,
       go_grid1      type ref to cl_gui_alv_grid.

"subscreen1 container
data : go_container2 type ref to cl_gui_custom_container,
       go_grid2      type ref to cl_gui_alv_grid.
"subscreen2 container
data : go_container3 type ref to cl_gui_custom_container,
       go_grid3      type ref to cl_gui_alv_grid.

"subscreen3 container
data : go_container4 type ref to cl_gui_custom_container,
       go_grid4      type ref to cl_gui_alv_grid.

"contoiner ekranındaki alv nin sutunlarındaki boşlukları
"otomatik olarak boşlukları temizler.
data bosluk_sil type lvc_s_layo.


"masraf verilerinin tutulacağı internal tablo
data masraf_sorgutablo type standard table of zeb_msf_masraf.

data masraf_tablocalisma  type standard table of zeb_msf_masraf with header line.

"alv satir index ve pop up değişkeni
data : alv_satir  type lvc_s_row,
        lv_ans  type c length 1."popup değişken

data alv_ismi type string.

data screen_yenile type c length 1.


*&---------------------------------------------------------------------*
*&          -----YÖNETİCİ KISMI-------
*&---------------------------------------------------------------------*


data sorumlupersonel type standard table of zeb_msf_personel.
data sorumlu type zeb_msf_personel.




data : field_id         type          vrm_id,  "list_box için gerekli tanımlamalar
       values           type          vrm_values,
       value            like line of  values.


data : field_id1         type          vrm_id,  "list_box için gerekli tanımlamalar
       values1           type          vrm_values,
       value1            like line of  values.

data : field_id2         type          vrm_id,  "list_box için gerekli tanımlamalar
       values2           type          vrm_values,
       value2            like line of  values.

data : pisim  type zeb_msf_personel-padi,
       pisim1 type zeb_msf_personel-padi.


data : sorumlusorgutablo  type standard table of zeb_msf_sorumlu,
       sorumlucalisamatablo type zeb_msf_sorumlu.

"yöneticinin sorumlu olduğu personelden hangileri olduğunu tutan internal tablo
data : personelid type standard table of zeb_msf_sorumlu-personelid,
       personelidno type zeb_msf_sorumlu-personelid.

data : sorumlupersoneller type standard table of zeb_msf_personel,
       sorumlupersonelcalisma type zeb_msf_personel.

"personel ekleme dataları
data : peadi        type zeb_msf_personel-padi,
       pesoyadi     type zeb_msf_personel-psoyadi,
       peunvan      type zeb_msf_personel-punvan,
       pepozisyon   type zeb_msf_personel-ppozisyon,
       pemail       type zeb_msf_personel-pmail,
       petarih      type zeb_msf_personel-pdtarih,
       peadres      type zeb_msf_personel-padres,
       pecinsiyet   type zeb_msf_personel-pcinsiyet,
       petelefon    type zeb_msf_personel-ptelefon.

"personel ekleme tablosu ve structerı
data : personelekleit     type zeb_msf_personel,
       personelekleitable type table of zeb_msf_personel.

data : kekleadi         type zeb_msf_kullanic-kullaniciadi,
       keklesifre       type zeb_msf_kullanic-kullanicisifre,
       keklesifretekrar type zeb_msf_kullanic-kullanicisifre,
       keklepersonelsec type zeb_msf_kullanic-kullanicisifre.

data : kullanicicalisma type zeb_msf_kullanic,
       kullanicitablo   type table of zeb_msf_kullanic.

data : personelcalisma        type zeb_msf_personel,
       personelcalismatablo   type standard table of zeb_msf_personel.

data smartformicin type zeb_msf_personel-padi.

*----------------------------------------------------------------------*
*       CLASS double_click_event DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class double_click_event definition.
 "alv griddeki çift tıklama olayı yakalayan methodlar
  public section.
    methods: handle_double_click
            for event double_click of cl_gui_alv_grid
      importing
         e_row,

         handle_double_click1
            for event double_click of cl_gui_alv_grid
         importing
            e_row,

          handle_double_click2
            for event double_click of cl_gui_alv_grid
          importing
              e_row,

          handle_double_click3
            for event double_click of cl_gui_alv_grid
          importing
              e_row.

endclass.                    "double_click_event DEFINITION
*----------------------------------------------------------------------*
*       CLASS double_click_event IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
class double_click_event implementation.
   "alv griddeki çift tıklama olayı yakalayan methodların açıklamaları
  method handle_double_click.
    perform pop_up.
    if lv_ans eq '1'.
      alv_satir-index = e_row-index.
      "alv satırı numarası alınır
      read table masraf_sorgutablo into masraf_tablocalisma index alv_satir-index.
      "internal tabloda değer okunur
      clear : mtur,mtutar,mbirim,mtarih,mbelgeno,maciklama.
      if sy-subrc eq 0.
        "o değerdeki satırın değerleri input/output field kısmına eklenir
        mtur      = masraf_tablocalisma-mturu.
        mtutar    = masraf_tablocalisma-mtutar.
        mbirim    = masraf_tablocalisma-mbirim.
        mtarih    = masraf_tablocalisma-mtarih+6(2) && '.' && masraf_tablocalisma-mtarih+4(2) && '.' && masraf_tablocalisma-mtarih(4).
        "mtarih    = |{ masraf_tablocalisma-mtarih date = user }|.
        "iki türlüde oluyor.
        mbelgeno  = masraf_tablocalisma-mbelgeno.
        maciklama = masraf_tablocalisma-maciklama.

        clear masraf_sorgutablo.
        "son olarak internal tabloya ekleme yapılarak alv ekranındada gösterilir
        insert masraf_tablocalisma into table masraf_sorgutablo.
        perform alv_yenile.
        call screen 101.
      else.
        "eğer alv ekranından okuma başarılı değilse hata mesajı geriye döndürür.
        message 'hata!!' type 'I'.
      endif.
    endif.
  endmethod.                    "handle_double_click
  "handle_double_click

  "subscreen 1
  method handle_double_click1.
    alv_satir-index = e_row-index.
    read table masraf_sorgutablo into masraf_tablocalisma index alv_satir-index.
    if sy-subrc eq 0.
      perform onay_red.
      if lv_ans eq '1'.
        masraf_tablocalisma-monay = 'ONAYLANDI'.
      else.
        masraf_tablocalisma-monay = 'REDDEDİLDİ'.
      endif.
    endif.
    clear masraf_sorgutablo.
    insert masraf_tablocalisma into table masraf_sorgutablo.
    update zeb_msf_masraf from table masraf_sorgutablo.
    if sy-subrc eq 0.
      message 'İşlem Başarıyla Gerçekleşti' type 'S'.
      perform yonetici_masraf_mail using masraf_tablocalisma-pid.
    endif.
    perform alv_yenile_sub1.
    call screen 0102.
  endmethod.                    "handle_double_click1

  "subscreen 2
  method handle_double_click2.
    alv_satir-index = e_row-index.
    read table personelekleitable into personelekleit index alv_satir-index.
    clear personelekleitable.
    insert personelekleit into table personelekleitable.

    peadi        = personelekleit-padi.
    pesoyadi     = personelekleit-psoyadi.
    peunvan      = personelekleit-punvan.
    pepozisyon   = personelekleit-ppozisyon.
    pemail       = personelekleit-pmail.
    petarih      = personelekleit-pdtarih.
    peadres      = personelekleit-padres.
    pecinsiyet   = personelekleit-pcinsiyet.
    petelefon    = personelekleit-ptelefon.

    perform alv_yenile_sub2.
    call screen 102.
  endmethod.                    "handle_double_click2

  "subscreen 3
  method handle_double_click3.
    alv_satir-index = e_row-index.
    clear : kullanicicalisma.
    read table kullanicitablo into kullanicicalisma index alv_satir-index.
    clear kullanicitablo.

    data personelverisi type zeb_msf_personel.

    kekleadi          = kullanicicalisma-kullaniciadi.
    keklesifre        = kullanicicalisma-kullanicisifre.
    keklesifretekrar  = kullanicicalisma-kullanicisifre.

    select single * from zeb_msf_personel as p into personelverisi where p~pid = kullanicicalisma-pid.
    keklepersonelsec  = personelverisi-pid && '-' && personelverisi-padi && '-' && personelverisi-psoyadi.

    alv_satir-index = kullanicicalisma-kullaniciid.
    insert kullanicicalisma into table kullanicitablo.
    perform alv_yenile_sub3.
    call screen 102.
  endmethod.                    "handle_double_click3
endclass.                    "double_click_event IMPLEMENTATION
data o_alv type ref to double_click_event.


start-of-selection.


  call screen 0100.
  "100 numaralı ekranı çağırır yani
  "kullanıcı giriş ekranını


*&---------------------------------------------------------------------*
*&          -----PERSONEL KISMI-------
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  container_olustur
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form container_olustur using alv_ismi.

  if go_container1 is not bound.
    create object go_container1
      exporting
        container_name              = alv_ismi
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
  endif.

  check go_container1 is bound.

  create object go_grid1
    exporting
      i_parent          = go_container1
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.
endform.                    "container_olustur

*&---------------------------------------------------------------------*
*&      Form  container_olustur_sub1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form container_olustur_sub1 using alv_ismi1.

  if go_container2 is not bound.
    create object go_container2
      exporting
        container_name              = alv_ismi1
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
  endif.

  check go_container2 is bound.

  create object go_grid2
    exporting
      i_parent          = go_container2
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.
endform.                    "container_olustur



*&---------------------------------------------------------------------*
*&      Form  container_olustur_sub2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->ALV_ISMI2  text
*----------------------------------------------------------------------*
form container_olustur_sub2 using alv_ismi2.

  if go_container3 is not bound.
    create object go_container3
      exporting
        container_name              = alv_ismi2
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
  endif.

  check go_container3 is bound.

  create object go_grid3
    exporting
      i_parent          = go_container3
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.
endform.                    "container_olustur


*&---------------------------------------------------------------------*
*&      Form  container_olustur_sub3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->ALV_ISMI3  text
*----------------------------------------------------------------------*
form container_olustur_sub3 using alv_ismi3.

  if go_container4 is not bound.
    create object go_container4
      exporting
        container_name              = alv_ismi3
      exceptions
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        others                      = 6.
  endif.

  check go_container4 is bound.

  create object go_grid4
    exporting
      i_parent          = go_container4
    exceptions
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      others            = 5.
endform.                    "container_olustur



"kullanıcı girişini kontrol eden formumuz
*&---------------------------------------------------------------------*
*&      Form  kullanicigirisi
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form kullanicigirisi.

  condense : kadi,ksifre. " arasındaki boşluklar temizlenir


  "kullanıcı tablosunda kullanıcı adı şifre uyuşursa personel tablosuyla
  "inner join yapılır ve giriş yapan personelin bilgileri çekilir.
  select single * into corresponding fields of personel
    from zeb_msf_kullanic as k
    inner join zeb_msf_personel as p on k~pid = p~pid
    where k~kullaniciadi = kadi and k~kullanicisifre = ksifre.

  "eğer veri çekme işi başarılı ise kullanıcı girişi yapılır
  if sy-subrc eq 0.
    "hoşgeldiniz mesajı yazdırılır.
    if personel-pcinsiyet eq 'ERKEK'.
      clear copstring.
      copstring = 'HOŞ  GELDİNİZ--' && personel-padi && '  BEY  '.
      message copstring  type 'I'.
    else.
      clear copstring.
      copstring = 'HOŞ  GELDİNİZ--' && personel-padi && '  HANIM  '.
      message copstring  type 'I'.
    endif.

    "pozisyona göre ekrana gönderme yapma.
    if personel-ppozisyon eq 'Y'.
      call screen 0102.
      screen_yenile = 2.
    elseif personel-ppozisyon eq 'P'.
      call screen 0101.
      screen_yenile = 1.
    endif.

  else.
    message 'Hatalı Kullanıcı Adı veya Parola.' type 'I'.
  endif.
  "veri çekme işi endif.

endform.                    "kullanicigirisi


"tarih oluşturtur formumuz
"PBO MODULES KISMI
*&---------------------------------------------------------------------*
*&      Form  tarih_olustur
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form tarih_olustur.
  lv_date = sy-datum.
  mtarih = lv_date.
endform.                    "tarih_olustur


"parolayı maile yollama fonksiyonu
*&---------------------------------------------------------------------*
*&      Form  mail
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form mail.
  if kadi is not initial.
    data lt_yazi type soli_tab with header line.
    data lt_users type table of zalfa_user_str with header line.

    select single kullaniciadi kullanicisifre pmail into (lt_users-uname,lt_yazi-line,lt_users-email)
      from zeb_msf_kullanic as k inner join zeb_msf_personel as p
      on k~pid = p~pid where k~kullaniciadi = kadi.

    if sy-subrc eq 0.
      append lt_users.

      lt_yazi-line =' Parolanız : ' && lt_yazi-line.
      append  lt_yazi.
      lt_yazi-line ='Kullanıcı adınız : ' && lt_users-uname.
      append lt_yazi.
      lt_yazi-line = ''.
      append lt_yazi.
      lt_yazi-line = 'ALFA YAZILIM DANIŞMANLIK'.
      append lt_yazi.

      call function 'Z_ALFA_MAIL'
        exporting
          i_subject = 'Parola bilgisi'
          i_text    = lt_yazi[]
        tables
          users     = lt_users[].

      message 'Parolanız mail adresinize gönderilmiştir !' type 'I'.
    else.
      message 'Kullanıcı kaydı veritabanında bulunamadı.' type 'I'.
    endif.
  else.
    message 'Kullanıcı adı kısmını boş bırakmayınız.!!' type 'I'.
  endif.

endform.                    "mail


*&---------------------------------------------------------------------*
*&      Form  personel_masraf_mail
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PERSONELID text
*----------------------------------------------------------------------*
form personel_masraf_mail using personelid.
  data lt_yazi type soli_tab with header line.
  data lt_users type table of zalfa_user_str with header line.

  data : personelim type zeb_msf_personel,
         yoneticibilgileri type zeb_msf_personel.

  data yoneticitablom type zeb_msf_sorumlu.

  select single * from zeb_msf_personel as p into personelim where p~pid eq personelid.

  select single * from zeb_msf_sorumlu as s into yoneticitablom where s~personelid eq personelid.

  select single * from zeb_msf_personel as p into yoneticibilgileri where p~pid eq yoneticitablom-yoneticiid .

  lt_users-email = yoneticibilgileri-pmail.
  lt_users-uname = yoneticibilgileri-padi.

  if sy-subrc eq 0.
    append lt_users.

    lt_yazi-line = 'Sorumlu olduğunuz'.
    append lt_yazi.

    lt_yazi-line = personelim-padi && ' isimli personelimiz masraf girişi/değiştirme işlemi yapmıştır bilginize'.
    append lt_yazi.

    lt_yazi-line = ' '.
    append lt_yazi.

    lt_yazi-line = 'ALFA YAZILIM DANIŞMANLIK'.
    append lt_yazi.

    call function 'Z_ALFA_MAIL'
      exporting
        i_subject = 'Masraf Giriş/değiştirme bilgilendirme'
        i_text    = lt_yazi[]
      tables
        users     = lt_users[].

    message 'Sorumlu olduğunuz kişiye mailiniz yollanmıştır!' type 'I'.
  else.
    message 'Kullanıcı kaydı veritabanında bulunamadı.' type 'I'.
  endif.
endform.                    "personel_masraf_mail

*&---------------------------------------------------------------------*
*&      Form  yonetici_masraf_mail
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PERSONELID text
*----------------------------------------------------------------------*
form yonetici_masraf_mail using personelid.

  data lt_yazi type soli_tab with header line.
  data lt_users type table of zalfa_user_str with header line.

  data : personelim type zeb_msf_personel,
         yoneticibilgileri type zeb_msf_personel.


  data yoneticitablom type zeb_msf_sorumlu.

  select single * from zeb_msf_personel as p into personelim where p~pid eq personelid.

  select single * from zeb_msf_sorumlu as s into yoneticitablom where s~personelid eq personelid.

  select single * from zeb_msf_personel as p into yoneticibilgileri where p~pid eq yoneticitablom-yoneticiid .

  lt_users-email = personelim-pmail.
  lt_users-uname = personelim-padi.

  if sy-subrc eq 0.
    append lt_users.

    lt_yazi-line =' Yöneticiniz masraf onay/red durumunu girmiştir.Bilginize'.
    append lt_yazi.

    lt_yazi-line = yoneticibilgileri-padi && '  ' && yoneticibilgileri-psoyadi.
    append lt_yazi.

    lt_yazi-line = ' '.
    append lt_yazi.

    lt_yazi-line = 'ALFA YAZILIM DANIŞMANLIK'.
    append lt_yazi.

    call function 'Z_ALFA_MAIL'
      exporting
        i_subject = 'Masraf Giriş/değiştirme bilgilendirme'
        i_text    = lt_yazi[]
      tables
        users     = lt_users[].

    message 'Personele mail yollanmıştır!' type 'S'.
  else.
    message 'Kullanıcı kaydı veritabanında bulunamadı.' type 'S'.
  endif.
endform.                    "personel_masraf_mail

*&---------------------------------------------------------------------*
*&      Form  EKLEVEGUNCELLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form ekle.
  perform pop_up.
  if  lv_ans eq '1'.

    if go_grid1 is not initial.
      call method go_grid1->free.
    endif.

    "input alanları dolu mu diye kontrol edilir
    if mtur is not initial and mtutar is not initial and mbirim is not initial and maciklama is not initial and mbelgeno is not initial.
      "en büyük id li değer seçilip 1 arttırarak database tablosuna ekleme yapılır
      "sap veritabanı tablolarında auto increment özelliği yok


      select max( mid ) into it_table-mid from zeb_msf_masraf.

      "sistemde bulunan kullanıcını id sini tabloya ekler
      "tabloda id foreign key ile personel tablosuna bağlı
      it_table-pid = personel-pid.
      it_table-mid = it_table-mid + 1.
      it_table-mturu = mtur.
      it_table-mtutar = mtutar.
      it_table-mbirim = mbirim.
      it_table-mtarih  = mtarih.
      it_table-maciklama = maciklama.
      it_table-mbelgeno = mbelgeno.
      it_table-monay = 'BEKLEMEDE'.

      insert into zeb_msf_masraf values it_table.

      if sy-subrc eq 0.
        message 'KAYIT BAŞARILI' type 'I'.
        "input alanları temizlenir.
        clear : mtur, mtutar, mbirim, maciklama, mbelgeno.

        "container oluşturuldu ve masraf tablosu temizlendi
        perform container_olustur using 'ALV1'.
        clear masraf_sorgutablo.

        select max( mid ) into it_table-mid from zeb_msf_masraf as m
          where m~pid eq personel-pid.

        select * from zeb_msf_masraf as m into table masraf_sorgutablo
           where m~mid = it_table-mid and m~pid = personel-pid.

        perform alv_yenile.


        perform personel_masraf_mail using personel-pid.

      else.
        message 'KAYIT BAŞARISIZ' type 'I'.
      endif.
    else.
      message 'LUTFEN TUM ALANLARI DOLDURUNUZ' type 'I'.
    endif.

    "seçilen satır.
    "set handler o_alv->handle_double_click for go_grid1.
  endif.
endform.                    " EKLEVEGUNCELLE

"belgne no ile masraf sorgulama.

*&---------------------------------------------------------------------*
*&      Form  sorgula
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sorgula.

  clear masraf_sorgutablo.

  if go_grid1 is not initial.
    call method go_grid1->free.
  endif.
  perform container_olustur using 'ALV1'.
  if mbelgeno1 is not initial.
    "container oluşturma fonksiyonu


    "belge no ile eşleşen masrafları listele
    "select ile veri çekilir.
    select * from zeb_msf_masraf as m into table masraf_sorgutablo
      where m~mbelgeno = mbelgeno1 and m~pid = personel-pid.

    "işlem başarılı ise sy-subrc sistem alanı sıfır olur değilse herhangi bir değer olur.
    if sy-subrc eq 0.
      message 'BELGE BULUNDU' type 'S'.

      perform alv_yenile.
    else.
      message 'BELGE BULUNAMADI' type 'S'.
    endif.
  else.
    "select ile tüm masraflar verileri çekilir.
    select * from zeb_msf_masraf as m into table masraf_sorgutablo
      where m~pid = personel-pid.

    "işlem başarılı ise sy-subrc sistem alanı sıfır olur değilse herhangi bir değer olur.
    if sy-subrc eq 0.
      message 'BELGE BULUNDU' type 'S'.
      perform alv_yenile.
    else.
      message 'BELGE BULUNAMADI' type 'S'.
    endif.
  endif.
endform.                    "sorgula



"giriş ekranındaki sistem bilgileri
*&---------------------------------------------------------------------*
*&      Form  SISTEM_BILGILERI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sistem_bilgileri .

  "sy-datum(2) ilk iki karakterini yazdır
  "sy-datum+4(3) 4 birim ilerle 3 karakter yazdır

  skullanici  = sy-uname.
*  STARIH     = sy-datum+6(2) && '.' && sy-datum+4(2) && '.' && sy-datum(4).
  starih      = |{ sy-datum date = user }|.
  ssaat       = sy-uzeit(2) && ':' && sy-uzeit+2(2).

endform.                    " SISTEM_BILGILERI

*&---------------------------------------------------------------------*
*&      Form  guncelle
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form guncelle.
  perform pop_up.
  if lv_ans eq '1'.
    masraf_tablocalisma-mturu     = mtur.
    masraf_tablocalisma-mtutar    = mtutar.
    masraf_tablocalisma-mbirim    = mbirim.
    masraf_tablocalisma-mtarih    = mtarih.
    masraf_tablocalisma-mbelgeno  = mbelgeno.
    masraf_tablocalisma-maciklama = maciklama.
    masraf_tablocalisma-monay     = 'BEKLEMEDE'.
    clear masraf_sorgutablo.

    "structer dan internal tablo ya aktarılır
    append masraf_tablocalisma to masraf_sorgutablo.

    "internal tablodan ise tabloya aktarılır
    update zeb_msf_masraf from table masraf_sorgutablo.

    if sy-subrc eq 0.
      message 'Güncelleme işlemi başarılı .' type 'I'.
      perform alv_yenile.
      perform personel_masraf_mail using personel-pid.
    else.
      message 'Başarısız.' type 'I'.
    endif.
  endif.
endform.                    "guncelle

*&---------------------------------------------------------------------*
*&      Form  alv_yenile
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv_yenile.
  check go_grid1 is bound.

  call method go_grid1->set_table_for_first_display
    exporting
      i_structure_name              = 'ZEB_MSF_MASRAF'
      is_layout                     = bosluk_sil
    changing
      it_outtab                     = masraf_sorgutablo
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.

  set handler o_alv->handle_double_click for go_grid1.


endform.                    "alv_yenile


*&---------------------------------------------------------------------*
*&      Form  SIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sil .
  perform pop_up.

  if lv_ans eq '1'.
    delete from zeb_msf_masraf where mid = masraf_tablocalisma-mid.

    if sy-subrc eq 0.
      message 'silme işlemi başarılı' type 'I'.
      clear masraf_sorgutablo.
      perform alv_yenile.
    else.
      message 'başarısız' type 'I'.
    endif.
  endif.
endform.                    " SIL




*&---------------------------------------------------------------------*
*&      Form  pop_up
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form pop_up.
  call function 'POPUP_TO_CONFIRM'
    exporting
      titlebar              = 'İşleminiz Gerçekleştiriliyor'
      text_question         = 'Emin misiniz ? '
      text_button_1         = 'TAMAM'
      icon_button_1         = 'ICON_CHECKED'
      text_button_2         = 'IPTAL'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '1'
      display_cancel_button = ' '
      popup_type            = 'ICON_MESSAGE_ERROR'
    importing
      answer                = lv_ans.
endform.                    "pop_up

*&---------------------------------------------------------------------*
*&      Form  onay_red
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form onay_red.
  call function 'POPUP_TO_CONFIRM'
    exporting
      titlebar              = 'İşleminiz Gerçekleştiriliyor'
      text_question         = 'Masraf Onayla Veya Reddet '
      text_button_1         = 'ONAYLA'
      icon_button_1         = 'ICON_CHECKED'
      text_button_2         = 'REDDET'
      icon_button_2         = 'ICON_CANCEL'
      default_button        = '1'
      display_cancel_button = ' '
      popup_type            = 'ICON_MESSAGE_ERROR'
    importing
      answer                = lv_ans.
endform.                    "pop_up

*&---------------------------------------------------------------------*
*&          -----PERSONEL KISMI-------
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&          -----YÖNETİCİ KISMI-------
*&---------------------------------------------------------------------*


"işlemlerin başladığı kısım

start-of-selection.

*&---------------------------------------------------------------------*
*&      Form  K_DEGISTIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form k_degistir .
  perform pop_up.

  if lv_ans eq '1'.
    if kekleadi is not initial and keklesifre is not initial and keklesifretekrar is not initial and keklepersonelsec is not initial.

      kullanicicalisma-kullaniciadi = kekleadi.
      kullanicicalisma-kullanicisifre = keklesifre.
      kullanicicalisma-pid = keklepersonelsec.

      update zeb_msf_kullanic from kullanicicalisma.

      if sy-subrc eq 0.
        message 'Değiştirme işlemi başarılı' type 'S'.
        clear :kullanicitablo, kekleadi,keklesifre,keklesifretekrar,keklepersonelsec.
        perform container_olustur_sub3 using 'ALV4'.
        perform alv_yenile_sub3.
        call screen 102.
      else.
        message 'Değiştirme işlemi başarısız' type 'S'.
      endif.
    endif.
  endif.
endform.                    " K_DEGISTIR



*&---------------------------------------------------------------------*
*&      Form  K_SIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form k_sil.
  perform pop_up.

  if lv_ans eq '1'.
    delete from zeb_msf_kullanic where kullaniciid eq alv_satir-index.

    if sy-subrc eq 0.
      message 'Silme işlemi başarılı' type 'S'.
      clear :kullanicitablo, kekleadi,keklesifre,keklesifretekrar,keklepersonelsec.
      call screen 102.
      perform alv_yenile_sub3.
    else.
      message 'Silme işlemi başarısız' type 'S'.
    endif.
  endif.
endform.                    " K_SIL


*&---------------------------------------------------------------------*
*&      Form  KULLANICI_LISTELE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form kullanici_listele .
  perform pop_up.
  if lv_ans eq '1'.

    if go_grid4 is not initial.
      call method go_grid4->free.
    endif.

    select * from zeb_msf_kullanic into table kullanicitablo.
    if sy-subrc eq 0.
      message 'Listeleme Başalarılı' type 'S'.
      perform container_olustur_sub3 using 'ALV4'.
      perform alv_yenile_sub3.
    endif.
  endif.
endform.                    " KULLANICI_LISTELE


*&---------------------------------------------------------------------*
*&      Form  KULLANICI_EKLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form kullanici_ekle .
  perform pop_up.
  if lv_ans eq '1'.

    if kekleadi is not initial and keklesifre is not initial and keklesifretekrar is not initial and keklepersonelsec is not initial.
      if keklesifre eq keklesifretekrar.
        if go_grid4 is not initial.
          call method go_grid4->free.
        endif.
        select max( kullaniciid ) from zeb_msf_kullanic into kullanicicalisma.

        kullanicicalisma-kullaniciid = kullanicicalisma-kullaniciid + 1.
        kullanicicalisma-kullaniciadi = kekleadi.
        kullanicicalisma-kullanicisifre = keklesifre.
        kullanicicalisma-pid = keklepersonelsec.

        insert zeb_msf_kullanic from kullanicicalisma.

        clear kullanicitablo.

        append kullanicicalisma to kullanicitablo.

        if sy-subrc eq 0.
          message 'Kullanıcı başarıyla eklendi' type 'S'.
          perform container_olustur_sub3 using 'ALV4'.
          perform alv_yenile_sub3.
          call screen 102.
        else.
          message 'Hata!!' type 'S'.
        endif.
      else.
        message 'Şifreyi aynı giriniz' type 'S'.
      endif.
    else.
      message 'Lütfen boş alan bırakmayınız' type 'S'.
    endif.
  endif.

endform.                    " KULLANICI_EKLE


*&---------------------------------------------------------------------*
*&      Form  PERSONEL_SIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form personel_sil .
  perform pop_up.
  if lv_ans eq '1'.
    delete from zeb_msf_personel where pid eq personelekleit-pid.
    if sy-subrc eq 0.
      message 'silme işlemi başarılı' type 'S'.
      clear personelekleitable.
      perform alv_yenile_sub2.
    else.
      message 'hata var' type 'S'.
    endif.
  endif.
endform.                    " PERSONEL_SIL




*&---------------------------------------------------------------------*
*&      Form  PERSONEL_DEGISTIR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form personel_degistir .
  perform pop_up.

  if lv_ans eq '1'.
    if peadres is not initial and peadi is not initial and pesoyadi is not initial and peunvan is not initial and pepozisyon is not initial and pemail is not initial and petarih is not initial and pecinsiyet is not initial and petelefon is not initial.

      personelekleit-padi      = peadi.
      personelekleit-psoyadi   = pesoyadi.
      personelekleit-punvan    = peunvan.
      personelekleit-ppozisyon = pepozisyon.
      personelekleit-pmail     = pemail.
      personelekleit-pdtarih   = petarih.
      personelekleit-padres    = peadres.
      personelekleit-pcinsiyet = pecinsiyet.
      personelekleit-ptelefon  = petelefon.

      clear personelekleitable.
      append personelekleit to personelekleitable.
      update zeb_msf_personel from personelekleit.
      if sy-subrc eq 0.
        message 'Başarıyla değiştirildi' type 'S'.
      else.
        message 'hata ' type 'S'.
      endif.

      perform alv_yenile_sub2.
    else.
      message 'Alanları boş bırakmayın' type 'S'.
    endif.
  endif.

endform.                    " PERSONEL_DEGISTIR




*&---------------------------------------------------------------------*
*&      Form  PERSONELLERI_LISTELE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form personelleri_listele .
  perform pop_up.
  if lv_ans eq '1'.

    if go_grid3 is not initial.
      call method go_grid3->free.
    endif.

    "container oluşturuldu ve personel tablosu temizlendi
    perform container_olustur_sub2 using 'ALV3'.

    perform alv_yenile_sub2.

    select * from zeb_msf_personel into table personelekleitable.
    if sy-subrc eq 0.
      message 'Başarıyla Listelendi' type 'S'.
    else.
      message 'Hata' type 'S'.
    endif.

  endif.
endform.                    " PERSONELLERI_LISTELE



*&---------------------------------------------------------------------*
*&      Form  PERSONEL_EKLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form personel_ekle .
  perform pop_up.
  if  lv_ans eq '1'.


    "boş alan olup olmadığı kontrol ediyor
    if peadres is not initial and peadi is not initial and pesoyadi is not initial and peunvan is not initial and pepozisyon is not initial and pemail is not initial and petarih is not initial and pecinsiyet is not initial and petelefon is not initial.


      if go_grid3 is not initial.
        call method go_grid3->free.
      endif.

      "auto increment özelliği sap de yoktur.
      "en büyük id li değer seçilip 1 arttırarak database tablosuna ekleme yapılır
      "sap veritabanı tablolarında auto increment özelliği yok

      select max( pid ) into personelekleit-pid from zeb_msf_personel.

      personelekleit-pid       = personelekleit-pid + 1.
      personelekleit-padi      = peadi.
      personelekleit-psoyadi   = pesoyadi.
      personelekleit-punvan    = peunvan.
      personelekleit-ppozisyon = pepozisyon.
      personelekleit-pmail     = pemail.
      personelekleit-pdtarih   = petarih.
      personelekleit-padres    = peadres.
      personelekleit-pcinsiyet = pecinsiyet.
      personelekleit-ptelefon  = petelefon.

      insert into zeb_msf_personel values personelekleit.

      append personelekleit  to personelekleitable.

      if sy-subrc eq 0.
        message 'KAYIT BAŞARILI' type 'I'.
        "input alanları temizlenir.
        clear : peadi,pesoyadi,peunvan,pepozisyon,pemail,petarih,pecinsiyet,petelefon.

        "container oluşturuldu ve personel tablosu temizlendi
        perform container_olustur_sub2 using 'ALV3'.
        clear personelekleit.

        select max( pid ) into personelekleit-pid from zeb_msf_personel.

        select single * from zeb_msf_personel as p into personelekleit
           where p~pid = personelekleit-pid.

        perform alv_yenile_sub2.

      else.
        message 'KAYIT BAŞARISIZ' type 'I'.
      endif.
    else.
      message 'LUTFEN TUM ALANLARI DOLDURUNUZ' type 'I'.
    endif.
  endif.

endform.                    " PERSONEL_EKLE


*&---------------------------------------------------------------------*
*&      Form  sorumlu_ekle
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sorumlu_ekle.
  if pisim1 is initial.
    message 'bir kayıt secin' type 'S'.
  else.
    data ekleme type n.

    select * from zeb_msf_sorumlu as s into table sorumlusorgutablo where s~personelid = pisim1.

    if sy-subrc eq 0.
      ekleme = 0.
    else.
      ekleme = 1.
    endif.

    "ekleme bölümü
    if ekleme eq 1.
      perform pop_up.
      if lv_ans eq 1.
        clear sorumlucalisamatablo.
        select max( sorumluid ) from zeb_msf_sorumlu into sorumlucalisamatablo-sorumluid.

        sorumlucalisamatablo-sorumluid = sorumlucalisamatablo-sorumluid + 1  .
        sorumlucalisamatablo-personelid = pisim1.
        sorumlucalisamatablo-yoneticiid = personel-pid.

        insert into zeb_msf_sorumlu values sorumlucalisamatablo.
        if sy-subrc eq 0.
          message 'Ekleme işlemi başarılı' type 'S'.
        endif.
      endif.
      "Çıkarma bölümü
    else.
      perform pop_up.
      if lv_ans eq 1.
        delete from zeb_msf_sorumlu where personelid = pisim1.
        if sy-subrc eq 0.
          message 'Çıkarma işlemi başarılı' type 'S'.
        endif.
      endif.
    endif.
  endif.
endform.                    "sorumlu_ekle

*&---------------------------------------------------------------------*
*&      Form  subscreen1_output
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form subscreen1_output .


  clear : value,values.
  select * from zeb_msf_personel as p into table sorumlupersonel where p~pid <> personel-pid and p~ppozisyon eq 'P' .
  field_id = 'PISIM1'.

  define list_box.
    value-key = &1.
    value-text = &2.
    append value to values.
  end-of-definition.

  data isimsoyisim type string.
  loop at sorumlupersonel into sorumlu.
    isimsoyisim = sorumlu-padi && '-' && sorumlu-psoyadi.
    list_box sorumlu-pid isimsoyisim.
    clear isimsoyisim.
  endloop.

  call function 'VRM_SET_VALUES'
    exporting
      id              = field_id
      values          = values
    exceptions
      id_illegal_name = 1
      others          = 2.


  "sorgu ile sorumlu tablosundan alınan veirler persoenlid internal tablosuna aktarılır
  select personelid from zeb_msf_sorumlu into table personelid where yoneticiid eq personel-pid.



  clear : value1,values1,pisim,sorumlupersonel,sorumlupersonelcalisma,sorumlupersoneller.

  "yöneticinin sorumlu olduğu personeller
  field_id1 = 'PISIM'.

  define list_box1.
    value1-key = &1.
    value1-text = &2.
    append value1 to values1.
  end-of-definition.


  loop at personelid into personelidno.
    select single * from zeb_msf_personel as p into sorumlupersonelcalisma where p~pid = personelidno.
    append sorumlupersonelcalisma to sorumlupersoneller.
  endloop.

  loop at sorumlupersoneller into sorumlupersonelcalisma.
    isimsoyisim = sorumlupersonelcalisma-padi && '-' && sorumlupersonelcalisma-psoyadi.
    list_box1 sorumlupersonelcalisma-pid isimsoyisim.
    clear isimsoyisim.
  endloop.


  call function 'VRM_SET_VALUES'
    exporting
      id              = field_id1
      values          = values1
    exceptions
      id_illegal_name = 1
      others          = 2.

  "subscreen 3 output.
  clear : value2 ,values2,personelcalisma,personelcalismatablo,kullanicicalisma,kullanicitablo.

  select * from zeb_msf_kullanic into table kullanicitablo.

  field_id2 = 'KEKLEPERSONELSEC'.

  define list_box2.
    value2-key = &1.
    value2-text = &2.
    append value2 to values2.
  end-of-definition.

  select * from zeb_msf_personel into table personelcalismatablo.

  loop at personelcalismatablo into personelcalisma.
    loop at kullanicitablo into kullanicicalisma.
      if personelcalisma-pid eq kullanicicalisma-pid.
        delete personelcalismatablo where pid eq kullanicicalisma-pid.
      endif.
    endloop.
  endloop.
*
*  LOOP AT kullanicitablo into kullanicicalisma.
*    select single * from zeb_msf_personel as p into personelcalisma where p~pid <> kullanicicalisma-pid.
*    append personelcalisma to personelcalismatablo.
*  ENDLOOP.
*
  loop at personelcalismatablo into personelcalisma.
    isimsoyisim = personelcalisma-padi && '-' && personelcalisma-psoyadi.
    list_box2 personelcalisma-pid isimsoyisim.
    clear isimsoyisim.
  endloop.

  call function 'VRM_SET_VALUES'
    exporting
      id              = field_id2
      values          = values2
    exceptions
      id_illegal_name = 1
      others          = 2.
endform.                    " SUBSCREEN1_OUTPUT



*&---------------------------------------------------------------------*
*&      Form  SORUMLU_LISTELE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sorumlu_listele .
  if pisim is initial.
    message 'bir kayıt secin' type 'S'.
  else.
    if go_grid2 is not initial.
      call method go_grid2->free.
    endif.

    select * from zeb_msf_masraf as m into table masraf_sorgutablo where m~pid = pisim.

    smartformicin = pisim.

    if sy-subrc eq 0.
      message 'Kayıtlar listelendi' type 'S'.
    else.
      message 'Kayıtlar listelenemedi' type 'S'.
      clear : masraf_sorgutablo,pisim.
    endif.
    perform container_olustur_sub1 using 'ALV2'.
    perform alv_yenile_sub1.
  endif.
endform.                    " SORUMLU_LISTELE


*&---------------------------------------------------------------------*
*&      Form  SORUMLU_HEPLISTELE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form sorumlu_heplistele .
  if go_grid2 is not initial.
    call method go_grid2->free.
  endif.

  select personelid from zeb_msf_sorumlu into table personelid where yoneticiid eq personel-pid.

  loop at personelid into personelidno.
    select * from zeb_msf_masraf as p into table masraf_sorgutablo where p~pid = personelidno.
  endloop.

  if sy-subrc eq 0.
    message 'Kayıtlar listelendi' type 'S'.
  else.
    message 'Kayıtlar listelenemedi' type 'S'.
    clear : masraf_sorgutablo,pisim.
  endif.
  perform container_olustur_sub1 using 'ALV2'.
  perform alv_yenile_sub1.
endform.                    " SORUMLU_HEPLISTELE



*&---------------------------------------------------------------------*
*&          -----YÖNETİCİ KISMI-------
*&---------------------------------------------------------------------*



include zeb_masraf_programi_status_o01.
include zeb_masraf_programi_user_coi01.
"0100 numaralı ekranların input ve output includeları.

include zeb_masraf_programi_status_o02.
include zeb_masraf_programi_user_coi02.
"0101 numaralı ekranların input ve output includeları.

include zeb_masraf_programi_status_o03.

include zeb_masraf_programi_user_coi03.


"tabstrip ekran kısmı wizard yarıdmıyla yapıldı ayarlandı.

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'YONETICI_EKRANI'
constants: begin of c_yonetici_ekrani,
             tab1 like sy-ucomm value 'YONETICI_EKRANI_FC1',
             tab2 like sy-ucomm value 'YONETICI_EKRANI_FC2',
             tab3 like sy-ucomm value 'YONETICI_EKRANI_FC3',
           end of c_yonetici_ekrani.
*&SPWIZARD: DATA FOR TABSTRIP 'YONETICI_EKRANI'
controls:  yonetici_ekrani type tabstrip.
data:      begin of g_yonetici_ekrani,
             subscreen   like sy-dynnr,
             prog        like sy-repid value 'ZEB_MASRAF_PROGRAMI',
             pressed_tab like sy-ucomm value c_yonetici_ekrani-tab1,
           end of g_yonetici_ekrani.

*&SPWIZARD: OUTPUT MODULE FOR TS 'YONETICI_EKRANI'. DO NOT CHANGE THIS L
*&SPWIZARD: SETS ACTIVE TAB
module yonetici_ekrani_active_tab_set output.
  g_yonetici_ekrani-pressed_tab = yonetici_ekrani-activetab.
  case g_yonetici_ekrani-pressed_tab.
    when c_yonetici_ekrani-tab1.
      g_yonetici_ekrani-subscreen = '0103'.
    when c_yonetici_ekrani-tab2.
      g_yonetici_ekrani-subscreen = '0104'.
    when c_yonetici_ekrani-tab3.
      g_yonetici_ekrani-subscreen = '0105'.
    when others.
*&SPWIZARD:      DO NOTHING
  endcase.
endmodule.                    "YONETICI_EKRANI_ACTIVE_TAB_SET OUTPUT

*&SPWIZARD: INPUT MODULE FOR TS 'YONETICI_EKRANI'. DO NOT CHANGE THIS LI
*&SPWIZARD: GETS ACTIVE TAB
module yonetici_ekrani_active_tab_get input.
  g_yonetici_ekrani-pressed_tab = yonetici_ekrani-activetab.
  ok_code = sy-ucomm.
  case ok_code.
    when c_yonetici_ekrani-tab1.
      g_yonetici_ekrani-pressed_tab = c_yonetici_ekrani-tab1.
    when c_yonetici_ekrani-tab2.
      g_yonetici_ekrani-pressed_tab = c_yonetici_ekrani-tab2.
    when c_yonetici_ekrani-tab3.
      g_yonetici_ekrani-pressed_tab = c_yonetici_ekrani-tab3.
    when others.
      g_yonetici_ekrani-pressed_tab = yonetici_ekrani-activetab.
*&SPWIZARD:      DO NOTHING
  endcase.

endmodule.                    "YONETICI_EKRANI_ACTIVE_TAB_GET INPUT

include zeb_masraf_programi_status_o04.

include zeb_masraf_programi_user_coi04.


*&---------------------------------------------------------------------*
*&      Form  alv_yenile_sub1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv_yenile_sub1.
  check go_grid2 is bound.
  bosluk_sil-cwidth_opt = 'X'.
  call method go_grid2->set_table_for_first_display
    exporting
      i_structure_name              = 'ZEB_MSF_MASRAF'
      is_layout                     = bosluk_sil
    changing
      it_outtab                     = masraf_sorgutablo
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  set handler o_alv->handle_double_click1 for go_grid2.

endform.                    "alv_yenile

*&---------------------------------------------------------------------*
*&      Form  alv_yenile_sub2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv_yenile_sub2.
  check go_grid3 is bound.
  bosluk_sil-cwidth_opt = 'X'.
  call method go_grid3->set_table_for_first_display
    exporting
      i_structure_name              = 'ZEB_MSF_PERSONEL'
      is_layout                     = bosluk_sil
    changing
      it_outtab                     = personelekleitable
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  set handler o_alv->handle_double_click2 for go_grid3.
endform.                    "alv_yenile


*&---------------------------------------------------------------------*
*&      Form  alv_yenile_sub3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form alv_yenile_sub3.
  check go_grid4 is bound.

  call method go_grid4->set_table_for_first_display
    exporting
      i_structure_name              = 'ZEB_MSF_KULLANIC'
      is_layout                     = bosluk_sil
    changing
      it_outtab                     = kullanicitablo
    exceptions
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      others                        = 4.
  set handler o_alv->handle_double_click3 for go_grid4.
endform.                    "alv_yenile

*&---------------------------------------------------------------------*
*&      Form  call_smart_form
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
form smart_form_personel .

  select * from zeb_msf_personel into table personelekleitable.

  if personelekleitable is not initial.
    call function '/1BCDWB/SF00000391'
      tables
        kullanicitablo = personelekleitable.
  endif.

endform.                    "call_smart_form
*&---------------------------------------------------------------------*
*&      Form  SMART_FROM_MASRAF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form smart_from_masraf .

  select * from zeb_msf_masraf as m into table masraf_sorgutablo where m~pid eq smartformicin.

  if go_grid2 is not initial.
    call function '/1BCDWB/SF00000393'
      tables
        masraftablosu = masraf_sorgutablo.
  endif.
endform.                    " SMART_FROM_MASRAF