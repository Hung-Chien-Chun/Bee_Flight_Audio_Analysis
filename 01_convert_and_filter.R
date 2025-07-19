## Convert .m4a to .wav and then read the audio
# install.packages("av")  # first-time only
library(av)
input_file <- "8.m4a"
av_audio_convert(input_file, "8.wav")

# install.packages("tuneR")
library(tuneR)
audio <- readWave("D1-CTL3.wav")

## Inspect object structure
# Check channels, bit depth, etc.
str(audio)

## Calculate duration
# Duration (s) = Number of samples / (sample-rate × channels)
num_samples <- length(audio@left)            # samples in left channel
sample_rate <- audio@samp.rate
channels     <- ifelse(audio@stereo, 2, 1)   # 2 for stereo, 1 for mono
duration     <- num_samples / (sample_rate * channels)
print(duration)

## Trim frequencies > 600 Hz via FFT
# FFT converts the whole signal into the frequency domain and
# returns amplitude for each frequency bin.

# install.packages("seewave")
library(seewave)
fft_result <- fft(audio@left)

# Amplitude
magnitude <- abs(fft_result)

# Frequency vector
n    <- length(fft_result)
freq <- seq(0, (n - 1) * (audio@samp.rate / n), by = audio@samp.rate / n)

# Zero-out amplitudes above 600 Hz
magnitude[freq > 600] <- 0
fft_result[freq > 600] <- 0  # zero the complex numbers themselves

# Plot spectrum up to 600 Hz
plot(
  freq[1:(n / 2)], magnitude[1:(n / 2)], type = "l",
  xlab = "Frequency (Hz)", ylab = "Magnitude", xlim = c(0, 600)
)

## Inverse FFT → time domain, then save filtered audio
time_domain_signal <- Re(fft(fft_result, inverse = TRUE)) / n
new_wave <- Wave(
  left      = time_domain_signal,
  samp.rate = audio@samp.rate,
  bit       = audio@bit
)
savewav(new_wave, f = audio@samp.rate, filename = "filtered_audio.wav")
