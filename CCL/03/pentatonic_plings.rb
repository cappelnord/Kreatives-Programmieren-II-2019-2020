live_loop :looped_scale do
  with_fx :echo, phase: 2/3.0 do
    play (scale :e5, :minor_pentatonic).choose, amp: 0.1
    sleep 0.25
  end
end

live_loop :looped_scale2 do
  with_fx :echo, phase: 2/3.0 do
    play (scale :e4, :minor_pentatonic).choose, amp: 0.1
    sleep 0.5
  end
end

live_loop :looped_scale3 do
  with_fx :echo, phase: 2/3.0 do
    play (scale :e3, :minor_pentatonic).choose, amp: 0.1
    sleep 1
  end
end
