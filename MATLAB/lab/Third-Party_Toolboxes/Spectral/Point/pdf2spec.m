function spec = pdf2spec(pdf, x);

fs = dlt(smooth(pdf,50), x);

spec = real(fs./(1-fs));
