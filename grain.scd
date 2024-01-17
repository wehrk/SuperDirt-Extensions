// Tukey windowed dirt_grain_envelope replacement

(
SynthDef("dirt_grain_envelope" ++ numChannels, { | out, sustain = 1, alpha = 1.0 |

	var signal = In.ar(out, numChannels);
	var tukeyWindow = {
		| phase, alpha |
		var twoDivAlpha = 2 / alpha;
		var alphaDivTwo = alpha / 2;

		var x = 0.5 * (1 + cos((phase * twoDivAlpha - (1)) * pi));
		var y = 0.5 * (1 + cos((phase * twoDivAlpha - (1 + twoDivAlpha)) * pi));

		var w1 = x * (phase < alphaDivTwo);
		var w2 = (1 - w1) * (phase >= alphaDivTwo) * (phase <= (1 - alphaDivTwo));
		var w3 = y * (phase > (1 - alphaDivTwo));

		var result = w1 + w2 + w3;

		result * (phase < 1);
	};

	var trig = Impulse.ar(0);
	var phase = Sweep.ar(trig, 1 / sustain);

	tukeyWindow = tukeyWindow.(phase, alpha.clip(0.01, 1));
	signal = signal * tukeyWindow;

	ReplaceOut.ar(out, signal);
}, [\ir, \ir, \ir]).add;
)