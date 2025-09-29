module WelcomeHelper
  def welcome_primary_button
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#FFA62B] hover:bg-[#F58E00] font-bold text-white text-[16px]"
  end
  def welcome_secondary_button_purple
    "flex flex-row gap-[1rem] items-center-safe rounded-full px-[1rem] py-[0.25rem] cursor-pointer bg-[#8B7DC3] hover:bg-[#6D5BB3] font-bold text-white text-[16px]"
  end
  def welcome_secondary_button
    "rounded-full px-[1rem] py-[0.25rem] cursor-pointer border border-solid border-[#8B7DC3] font-bold text-[#8B7DC3] text-[16px] hover:underline"
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
end
