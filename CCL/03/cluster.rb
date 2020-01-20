live_loop :cluster do
  play rrand(20, 80), attack: 4, decay: 4, amp: 0.1, pan: rrand(-1, 1).
  sleep rrand(0.5, 3)
end