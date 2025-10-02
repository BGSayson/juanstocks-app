module WelcomeHelper
  def welcome_primary_button
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#FFA62B] hover:bg-[#F58E00] font-bold text-white text-[16px]"
  end
  def welcome_secondary_button_purple
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#8B7DC3] hover:bg-[#6D5BB3] font-bold text-white text-[16px]"
  end
  def welcome_secondary_button
    "rounded-full px-[1rem] py-[0.25rem] cursor-pointer border-[2px] border-solid border-[#8B7DC3] font-bold text-[#8B7DC3] text-[20px] hover:underline"
  end
  def welcome_delete_button
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#EA4D4D] hover:bg-[#E52020] font-bold text-white text-[16px]"
  end
  def welcome_flex_col_container
    "flex flex-col"
  end
  def welcome_flex_row_container_top
    "px-[1rem] py-[0.5rem] flex flex-row gap-[1rem] items-center-safe justify-between bg-[#8B7DC3]"
  end
  def welcome_flex_row_container
    "flex flex-row gap-[1rem] items-center-safe"
  end
  def devise_form_buttons
    "gap-[1rem] rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#FFA62B] hover:bg-[#F58E00] font-bold text-white text-[20px] mb-3"
  end
  def devise_form_flex_col_container
    "flex flex-col items-center justify-center gap-[1rem]"
  end
  def devise_form_label_tf_div
    "field text-[1.5rem] mt-[1rem]"
  end
  def devise_form_parent_container
    "bg-[#f1eff7] px-[2rem] py-[2rem] rounded-[15px] gap-[1.5rem]"
  end
end
