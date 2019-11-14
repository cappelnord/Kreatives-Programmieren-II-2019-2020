# This is the musical scale random notes are selected from.
# Instead of :minor_pentatonic you could use:
# :major, :minor or :chromatic

main_scale = :minor_pentatonic

# Change the root note to another note
# e.g. d5, e5, f5, ...

main_root = :c5

# Add other notes to the bass_scale list
# e.g. :d2, :e2, :f2, :a2, :b2, ... (seperated with commas)
bass_scale = [:c2, :g2].ring

live_loop :bass do
  
  # Change the bass synth. Try :chipbass or :prophet instead of :fm
  use_synth :fm
  
  play choose(bass_scale),
    cutoff: 100,
    depth: 0.5,
    # Change release to 0.5 to make the bass sound shorter
    release: 2,
    # Change amp from 0.7 to 0.9 to make the bass louder
    amp: 0.6
  
  # Exchange the 3 with a 1 for a faster bass line
  sleep choose([1.5, 1, 0.5]) * 3
end


# Try changing the num_octaves from 2 to 3 or 4.
# Hear the difference!

treble_scale = scale(main_root, main_scale, num_octaves: 2)

with_fx :echo, phase: 3.0/8.0, decay: 3 do
  live_loop :treble do
    # Change the synth from :beep to :pretty_bell or :zawa
    use_synth :beep
    
    play choose(treble_scale),
      amp: rrand(0.2, 0.3),
      pan: rrand(-0.5, 0.5)
    
    # Add values to the [2, 4, 6] list (seperated by commas)
    # Add a 8 to introduce a chance for a long wait time
    # Add one 0.25 for a chance for quick successions
    sleep choose([2, 4, 6])
  end
end

blade_scale =  scale(main_root, main_scale, num_octaves: 2)
with_fx :echo, phase: 2.0/8.0, decay: 8 do
  with_fx :reverb do
    live_loop :main1 do
      
      # Use a different synth here, e.g. :chiplead or :prophet
      use_synth :blade
      
      play choose(blade_scale),
        cutoff: rrand(78, 83),
        pan: rrand(-0.5, 0.5),
        amp: 0.65,
        attack: 0.3,
        # Change release from 2 to 10 for longer synths
        release: 2
      
      # Change the 0.5 to a 0.125 to spawn more synths
      sleep choose([2, 4, 5, 6]) * 0.5
    end
  end
end


percs = [:tabla_tas1, :tabla_ke1, :tabla_ke2, :tabla_te1,
         :tabla_te2, :tabla_te_ne, :tabla_te_m, :tabla_na_s]

with_fx :echo, phase: 6.0/8.0, decay: 4 do
  live_loop :perc do
    sample choose(percs),
      # Change the 90 to 120 to make the tabla sound brighter
      lpf: 90,
      pan: rrand(-0.75, 0.75)
    
    # Add or remove some values in this list.
    sleep choose([0.5, 0.5, 1.0, 0.25, 2])
  end
end

live_loop :kick do
  # Try other kick samples instead of :drum_heavy_kick ...
  # ... maybe :bd_808, :bd_haus, :bd_tek
  sample :drum_heavy_kick,
    lpf: 60,
    # Higher values for rate will make the kick sound higher
    rate: 1.1,
    # Changing the amp from 2 to 4 will make the kick louder
    amp: 2
  
  # Add or remove some values from/to this list.
  # Leave only a 1 in the list for a steady beat
  sleep choose([3, 2, 1, 0.5, 0.25])
end

hats = [:drum_cymbal_closed, :perc_snap, :elec_tick]

# Remove the # from the next line to change sounds

# hats = [:perc_bell, :perc_swash, :perc_till, :sn_dub]

with_fx :reverb, damp: 0.8, room: 0.8 do
  with_fx :echo, phase: 3.0/8.0, decay: 3 do
    live_loop :hi_perc do
      
      # Add other sounds to this list, like:
      # :elec_triangle, :elec_cymbal, :elec_blup, :elec_plip, :elec_tick
      sample choose([:tabla_dhec, :tabla_re]),
        amp: rrand(0.35, 0.65),
        pan: rrand(-0.25, 0.25),
        lpf: rrand(80, 120),
        # Change the rate to 4.0.
        # You can also try to randomize with rrand(0.5, 4.0)
        rate: 1.0
      
      sleep choose([0.25, 0.5, 0.125])
      
      sample choose(hats),
        amp: rrand(0.6, 0.8),
        pan: rrand(-1.0, 1.0),
        lpf: rrand(110, 128),
        # Use a higher number instead of 1 for lower percussions
        rate: rrand(5.0, 8.0) / 1
      
      # Introduce odd numbers like 0.32 and listen what happens
      sleep choose([0.125, 0.25, 0.25, 0.5, 0.5, 3])
    end
  end
end

