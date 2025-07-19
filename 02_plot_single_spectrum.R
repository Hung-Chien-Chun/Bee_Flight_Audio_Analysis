####################################################################
# Plot the full-file spectrum (0–500 Hz) for a single filtered .wav
####################################################################
library(tuneR)
library(ggplot2)

audio <- readWave("filtered_audio.wav")

# FFT and amplitude
spectrum <- abs(fft(audio@left))
freq     <- seq(0, length(spectrum) - 1) * (audio@samp.rate / length(spectrum))

# Keep first half (positive freqs) and 0–500 Hz
spectrum_data <- data.frame(
  frequency = freq[1:(length(freq) / 2)],
  amplitude = spectrum[1:(length(spectrum) / 2)]
) |>
  subset(frequency <= 500)

# Plot
p <- ggplot(spectrum_data, aes(frequency, amplitude)) +
  geom_line(color = "black") +
  labs(
    title = "Frequency Spectrum of Bee Sound (0–500 Hz)",
    x = "Frequency (Hz)", y = "Amplitude"
  ) +
  theme_minimal() +
  scale_x_continuous(breaks = seq(0, 500, 100)) +
  xlim(0, 500)

print(p)
ggsave("frequency_spectrum.png", plot = p, width = 8, height = 6, bg = "white")
dev.off()
