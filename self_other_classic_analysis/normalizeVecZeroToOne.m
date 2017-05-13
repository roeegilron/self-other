function scaledI = normalizeVecZeroToOne(I)
scaledI = (I-min(I(:))) ./ (max(I(:)-min(I(:))));
end