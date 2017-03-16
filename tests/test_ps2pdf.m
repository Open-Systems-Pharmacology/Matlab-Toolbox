function test_ps2pdf

h=figure('visible','off');
spy;
print('-dpsc','test.ps');
clf;
for ii=1:5,
  text(.5,.5,num2str(ii),'fontunits','centim','fontsize',10)
  axis off;
  print('test.ps','-append','-dpsc');
  clf;
end
close(h)
msg=ps2pdf_MoBi('test.ps','test.pdf', 'gspapersize', 'a4','verbose',1)
% ps2pdf('psfile', 'test.ps', 'pdffile', 'test.pdf', 'gspapersize', 'a4');
