require_relative '../../base/base_page'
require_relative '../locator/locator_cart'

class PosCartPage < SitePrism::Page
    include BasePage
    include LocatorCartPage
  
    config = get_config_data('pos')
    set_url(config['url'])

    #object repository
    element :pos_cart_section_pic, PIC_SECTION
    element :pos_cart_select_pic, PIC_SELECT
    element :pos_cart_toggle_nonMember, :xpath, TOGGLE_NON_MEMBER
    element :pos_cart_inputNama_nonMember, :xpath, NAMA_NON_MEMBER_FIELD
    element :pos_cart_inputNohp_nonMember, :xpath, NOHP_NON_MEMBER_FIELD
    element :pos_cart_inputEmail_nonMember, :xpath, EMAIL_NON_MEMBER_FIELD
    element :pos_cart_btnConfirm_nonMember, :xpath, BTN_CONFIRM_NON_MEMBER
    element :pos_cart_searchSKU, :xpath, SEARCH_SKU
    element :pos_cart_typingSKU, TYPING_SKU
    element :pos_cart_ctaLanjutkan, :xpath, BTN_LANJUTKAN
    element :pos_badges_user, :xpath, BADGES_USER
    element :pos_error_nama_nonMember, :xpath, ERROR_NAMA_NON_MEMBER
    element :pos_error_noHp_nonMember, :xpath, ERROR_HOHP_NON_MEMBER
    element :pos_error_email_nonMember, :xpath, ERROR_EMAIL_NON_MEMBER
    element :pos_cart_inputNama_member, :xpath, SEARCH_MEMBER

    #methods
    def click_pic_section
        pos_cart_section_pic.click
    end

    def input_pic_name(pic)
        find(:xpath, "//div[@class='css-1su63w0-menu']//p[contains(text(), '#{pic}')]").click
    end

    def click_toggle_nonMember
        pos_cart_toggle_nonMember.click
        sleep 1
    end

    def input_nama_nonMember(namaNonMember)
        pos_cart_inputNama_nonMember.set(namaNonMember)
        sleep 1
    end

    def input_noHp_nonMember(noHpNonMember)
        pos_cart_inputNohp_nonMember.set(noHpNonMember)
        sleep 1
    end

    def input_email_nonMember(emailNonMember)
        pos_cart_inputEmail_nonMember.set(emailNonMember)
        sleep 1
    end

    def searching_SKU (sku)
        pos_cart_searchSKU.set(sku)
        wait_in_sec(1)
        page.send_keys (:enter)
        wait_in_sec(1)
        find(:xpath, "(//div[@class='Toastify']//div)[1]").should be_visible 
    end

    def searching_Member (emailMember)
        pos_cart_inputNama_member.set(emailMember)
        wait_in_sec(2)
        page.send_keys (:enter)
        wait_in_sec(1)
        find(:xpath, "//div[text()='order test bay - 6281311435055 - baytestorder2@yopmail.com']/following-sibling::div").should be_visible
    end

    def click_confirm_nonMember
        pos_cart_btnConfirm_nonMember.click
        sleep 3
    end

    def click_to_checkout_page
        pos_cart_ctaLanjutkan.click
        sleep 2
    end

    def verify_badgesUser
        pos_badges_user.should be_visible
    end

    def inputFieldNama(nama, element)
       element.set(nama)
    end

    def delete_nama_non_member
        pos_cart_inputNama_nonMember.click
        pos_cart_inputNama_nonMember.native.clear
    end

    def inputFieldHoHp(nohp, element)
        element.set(nohp)
    end

    def delete_no_hp_non_member
        pos_cart_inputNohp_nonMember.click
        pos_cart_inputNohp_nonMember.native.clear
    end

    def invalid_email_non_member(invalidEmailNonMember)
        pos_cart_inputEmail_nonMember.set (invalidEmailNonMember)
    end

    def delete_email_non_member
        4.times do 
            pos_cart_inputEmail_nonMember.send_keys :backspace  
        end
    end

    def validateInputError
        wait_in_sec 2
        pos_error_nama_nonMember.should be_visible
        pos_error_noHp_nonMember.should be_visible
        pos_error_email_nonMember.should be_visible
    end
end
