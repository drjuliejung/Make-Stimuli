%generate_bandpass_filtered_white_noise_id (sampling_rate, cutoff1, cutoff2, num_cycles, i_length, d_length)
Y= generate_bandpass_filtered_white_noise_id (22050, 1, 80, 500, 0.5, 0.1);

audiowrite('6dstimfast.wav',Y,22050,'BitsPerSample',64);