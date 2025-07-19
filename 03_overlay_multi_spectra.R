#############################################################################
# Overlay spectra for 10 filtered files (5 CTL, 5 PQQ).                     #
# Also compute mean frequency & amplitude within ±25 Hz of the peak (200–250 Hz). #
#############################################################################

library(tuneR)
library(ggplot2)
library(dplyr)

combined_spectra <- data.frame()

# File list (already FFT-filtered)
audio_files <- c(
  "D1-CTL1 filtered.wav", "D1-CTL2 filtered.wav", "D1-CTL3 filtered.wav",
  "D1-CTL4 filtered.wav", "D1-CTL5 filtered.wav",
  "D1-PQQ1 filtered.wav", "D1-PQQ2 filtered.wav", "D1-PQQ3 filtered.wav",
  "D1-PQQ4 filtered.wav", "D1-PQQ5 filtered.wav"
)

colors <- c(rep("black", 5), rep("red", 5))

average_frequencies <- numeric(length(audio_files))
average_amplitudes  <- numeric(length(audio_files))

for (i in seq_along(audio_files)) {
  audio <- readWave(audio_files[i])

  # FFT
  spectrum <- abs(fft(audio@left))
  freq     <- seq(0, length(spectrum) - 1) * (audio@samp.rate / length(spectrum))

  spectrum_data <- data.frame(
    frequency = freq[1:(length(freq) / 2)],
    amplitude = spectrum[1:(length(spectrum) / 2)]
  ) |>
    subset(frequency <= 500)

  # Peak in 200–250 Hz
  max_point <- spectrum_data |>
    filter(frequency > 200 & frequency < 250) |>
    slice(which.max(amplitude))

  max_freq <- max_point$frequency

  # Points within ±25 Hz of that peak
  selected <- spectrum_data |>
    filter(frequency >= max_freq - 25 & frequency <= max_freq + 25)

  average_frequencies[i] <- mean(selected$frequency)
  average_amplitudes[i]  <- mean(selected$amplitude)

  spectrum_data$source <- paste("Test", i - 1)
  combined_spectra     <- bind_rows(combined_spectra, spectrum_data)
}

# Scatter overlay
p <- ggplot(combined_spectra, aes(frequency, amplitude, color = source)) +
  geom_point(size = 0.3) +
  labs(
    title = "Combined Frequency Spectrum of Bee Sounds (0–500 Hz)",
    x = "Frequency (Hz)", y = "Amplitude"
  ) +
  theme_minimal() +
  scale_color_manual(values = colors) +
  scale_x_continuous(breaks = seq(0, 500, 100)) +
  xlim(0, 500)

print(p)
ggsave("combined_frequency_spectrum_with_avg_freqs.png", plot = p, bg = "white")

# Summary CSV
averages_df <- data.frame(
  File          = audio_files,
  Avg_Frequency = average_frequencies,
  Avg_Amplitude = average_amplitudes
)
write.csv(averages_df, "average_frequencies_amplitudes.csv", row.names = FALSE)
