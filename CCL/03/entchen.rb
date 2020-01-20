use_bpm 120 # Beats per Minute
use_synth :fm
use_synth_defaults divisor: 0.5

bpm = 120

play 60
sleep 0.5
play 62
sleep 0.5
play 64
sleep 0.5
play 65
sleep 0.5
play 67
sleep 1
play 67
sleep 1
2.times do
  4.times do
    play 69
    sleep 0.5
  end
  play 67
  sleep 2
end












# play [60, 64, 67]