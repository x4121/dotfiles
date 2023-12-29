# Disabling trackpad

## Find trackpad

`xinput list`

```sh
⎡ Virtual core pointer                          id=2  [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4  [slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad                id=10 [slave  pointer  (2)] <--
⎜   ↳ TPPS/2 IBM TrackPoint                     id=11 [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3  [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5  [slave  keyboard (3)]
    ↳ Power Button                              id=6  [slave  keyboard (3)]
    ↳ Video Bus                                 id=7  [slave  keyboard (3)]
    ↳ Sleep Button                              id=8  [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=9  [slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                    id=12 [slave  keyboard (3)]
```

## Disable

`xinput set-prop 10 "Device Enabled" 0`
