module AdminsHelper
  def admin_logo_text
    "font-bold text-[21px] text-white"
  end
  def admin_sign_out_button
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#8B7DC3] hover:bg-[#6D5BB3] font-bold text-white text-[16px]"
  end
  def admin_flex_row_container_top
    "px-[1rem] py-[0.5rem] flex flex-row gap-[1rem] items-center-safe justify-between bg-[#8B7DC3]"
  end
  def admin_flex_row_container
    "flex flex-row gap-[1rem] items-center-safe"
  end
  def admin_flex_col_container
    "flex flex-col gap-[1rem]"
  end
  def admin_main_header
    "text-[21px] text-[#111] font-bold"
  end
  def admin_dashboard_button
    "flex flex-row gap-[1rem] items-center-safe px-[1rem] py-[0.25rem] cursor-pointer bg-[#8B7DC3] hover:bg-[#FFA62B] font-bold text-white text-[16px]"
  end
  def admin_divider
    "h-0.5 bg-[#8B7DC3]"
  end
  def admin_mini_header
    "text-[18px] text-[#111] font-bold"
  end
  def admin_mini_button
    "cursor-pointer bg-[#8B7DC3] hover:bg-[#FFA62B] px-[0.5rem] py-[0.5rem] rounded-lg"
  end
  def admin_table
    "table-fixed border-collapse text-center"
  end
  def admin_thead_border
    "border-solid border-b-2 border-[#8B7DC3] text-[#45454560]"
  end
  def admin_tr_space
    "py-[0.1rem]"
  end
end
