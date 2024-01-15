// Perc'd 303

(
SynthDef(\dica, { | out, wave = 0, freq = 220, lag = 0.2, peak = 0.5, res = 0.5, dist = 0.5, attack = 0.01, decay = 0.5, sustain = 0.0, release = 1.0, curve = -3, pan = 0.0, amp = 1.0 |
	var saw, pulse, eg, sig;
	freq = freq.lag(lag);
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

TidalCycles parameters:

res = pF "res"
peak = pF "peak"
dist = pF "dist"
decay = pF "decay"
lag = pF "lag"
wave = pF "wave"

*/