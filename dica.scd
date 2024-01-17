// Perc'd 303

(
SynthDef(\dica, { | out, wave = 0, freq = 220, peak = 0.5, res = 0.5, dist = 0.5, attack = 0.01, decay = 0.5, sustain = 0.0, release = 1.0, curve = -3, pan = 0.0, amp = 1.0, accelerate, slidetime|
	var saw, pulse, eg, sig;
	freq = freq * Line.kr(1, 1 + accelerate, slidetime * sustain);
	saw = Saw.ar(freq)!2;
	pulse = Pulse.ar(freq)!2;
	sig = SelectX.ar(wave, [saw, pulse]);
	eg = Env.perc(attack, decay, 1e4 * peak, curve).kr(0, 1, timeScale: sustain);
	eg = eg.clip(20, 2e4);
	sig = RLPFD.ar(sig, eg, res, dist);
	sig = sig * Env.adsr(attack, decay, 1.0, release, amp, curve).kr(2, 1, timeScale: sustain);
	sig = DirtPan.ar(sig, ~dirt.numChannels, pan);
	OffsetOut.ar(out, sig);
}).add;
)

/*

let slide x = accelerate (2 **| (x |/ 12) - 1)
slidetime = pF "slidetime"
peak = pF "peak"
res = pF "res"
decay = pF "decay"
wave = pF "wave"
dist = pF "dist"


d1
    $ off (1/48) (|* n (slow 2 sine))
    $ s "dica"
    -- >| n ("[-16 4 [-8|11] -4]*16" * "[-2 2]*8")
    >| n "[1 2 3 4 5 6 7 8]*6"
    # peak (range 0.1 0.8 $ fast 8 perlin)
    # res 0.3
    # attack (slow 2 ((sine * 0.1) + 0.01))
    # decay 2
    # legato 5
    # release 0.3
    # dist 4
    # wave (slow 4 perlin)

*/