module ApplicationHelper
  def navbar_icons
    "flex items-center justify-center p-3 hover:bg-[#FFA62B] gap-3 hover:cursor-pointer"
  end

  def gridParent
    "flex items-start justify-center w-full h-full bg-white"
  end

  def gridChild
    "m-auto grid grid-cols-[0.2fr_1fr] w-full h-full"
  end

  # TX FORM Styles

  def hiddenClass
    "hidden flex flex-col items-center justify-center p-4 w-full w-[80%]"
  end

  def hiddenClassParent
    "bg-[#8B7DC3] rounded-[15px] flex flex-col items-center justify-center font-bold text-[1.5rem] text-white w-[80%] m-5"
  end


  def round_off(num)
    if num < 1000
      number_to_currency(num, unit: "")
    else
      number_to_currency(num / 100.0, unit: "")
    end
  end
end
