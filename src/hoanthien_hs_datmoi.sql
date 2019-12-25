PROCEDURE HOANTHIEN_HS_DATMOI(
        vhdtb_id    in NUMBER,
        vmay_cn     in varchar ,
        vngay_cn    in date,
        vnguoi_cn   in varchar
    ) is
    vthuebao_id         NUMBER;
    vthanhtoan_id       NUMBER;
    vkhachhang_id       NUMBER;
    vmig_id             NUMBER;
    vhdkh_id            NUMBER;
    vhdtt_id            NUMBER;
    vhdmig_id           NUMBER;
    vma_kh              varchar(30);
    vma_tt              varchar(30);
    vmain_ghep          varchar(60);
    vma_gd              varchar(50);
    vcount              NUMBER;
    vkieuld_id          number;  --kieu lap dat
    vloaitb_id        number;
    vma_tb              varchar(30);
    vkld number;
    begin
        select kieuld_id into vkld
        from hd_thuebao where hdtb_id=vhdtb_id;

        if(vkld=700)then
            css_hpg.hths_fsecure_kem_fiber_v3(vhdtb_id, vngay_cn);
        else
            select a.ma_kh, b.ma_tt, a.hdkh_id, b.hdtt_id, nvl(b.thanhtoan_id,0), nvl(a.khachhang_id,0),
                    a.ma_gd, nvl(d.mig_id,0),d.main_ghep,nvl(d.hdmig_id,0),
                    c.kieuld_id, c.ma_tb, c.loaitb_id
                into vma_kh, vma_tt, vhdkh_id, vhdtt_id, vthanhtoan_id, vkhachhang_id,
                    vma_gd,vmig_id,vmain_ghep,vhdmig_id,
                    vkieuld_id, vma_tb, vloaitb_id
            from hd_khachhang a, hd_thanhtoan b, hd_thuebao c,hd_mig d
            where a.hdkh_id = b.hdkh_id
                and a.hdkh_id = c.hdkh_id
                and b.hdtt_id = c.hdtt_id
                and b.hdmig_id = d.hdmig_id (+)
                and c.hdtb_id = vhdtb_id;

            if(vkhachhang_id=0) then
                select nvl(max(khachhang_id),0) into vkhachhang_id
                from db_khachhang where ma_kh = vma_kh;

                if(vkhachhang_id=0) then
                    vkhachhang_id := ADMIN_HPG.GET_KEYS('DB_KHACHHANG',1,10);
                    THEM_DBKH_HDKH(vhdkh_id, vkhachhang_id, vmay_cn, vngay_cn, vnguoi_cn);
                else
                    CAPNHAT_DBKH_HDKH(vhdkh_id, vkhachhang_id);
                end if;
            else
                CAPNHAT_DBKH_HDKH(vhdkh_id, vkhachhang_id);
            end if;


            if(vhdmig_id <> 0) then
                if(vmig_id=0) then
                    select nvl(max(mig_id),0) into vmig_id
                    from db_mig where main_ghep = vmain_ghep;
                    if(vmig_id=0) then
                        vmig_id := ADMIN_HPG.GET_KEYS('DB_MIG',1,10);
                        THEM_DBMIG_HDMIG(vhdmig_id, vmig_id, vkhachhang_id, vmay_cn, vngay_cn, vnguoi_cn);
                    else
                        CAPNHAT_DBMIG_HDMIG(vhdmig_id, vmig_id);
                    end if;
                else
                    CAPNHAT_DBMIG_HDMIG(vhdmig_id, vmig_id);
                end if;
            end if;


            if(vthanhtoan_id=0) then
                select nvl(max(thanhtoan_id),0) into vthanhtoan_id
                from db_thanhtoan where ma_tt = vma_tt;

                if(vthanhtoan_id=0) then
                    vthanhtoan_id := ADMIN_HPG.GET_KEYS('DB_THANHTOAN',1,10);
                    THEM_DBTT_HDTT(vhdtt_id, vthanhtoan_id, vkhachhang_id, vmay_cn, vngay_cn, vnguoi_cn);
                else
                    CAPNHAT_DBTT_HDTT(vhdtt_id, vthanhtoan_id);
                end if;
            else
                CAPNHAT_DBTT_HDTT(vhdtt_id, vthanhtoan_id);
            end if;

            If(vkieuld_id =  540 or vkieuld_id = 557) then --Neu thue so cu da su dung
                Capnhat_thueso_cu(vhdtb_id);
            else
                THEM_DBTB_HDTB(vhdtb_id, vthanhtoan_id, vkhachhang_id, vmay_cn, vngay_cn, vnguoi_cn);
            end if;

            HOANTHIEN_HS_LIENHE(vhdkh_id);
            HOANTHIEN_HS_EMAIL_USER(vhdkh_id);
            --- minhnt them code insert dbtb_nhanvien
            hoanthien_hoso.HOANTHIEN_DBTB_NHANVIEN(vhdtb_id, LOAINV_KYTHUAT);--ky thuat
            hoanthien_hoso.HOANTHIEN_DBTB_NHANVIEN(vhdtb_id, LOAINV_KINHDOANH);--kinh doanh
            hoanthien_hoso.HOANTHIEN_DBTB_KV(vhdtb_id, 4); --hths dbtb kv khoan dia ban
            commit;

            Hths_fsecure_kem_fiber(vhdtb_id, vmay_cn, vngay_cn, vnguoi_cn);
        end if;
    end;