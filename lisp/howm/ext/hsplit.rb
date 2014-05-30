#!/usr/bin/ruby -s
# -*- coding: euc-jp -*-
# -*- Ruby -*-

def usage
  name = File::basename $0
  print <<EOU
#{name}: howm ����, �����ե������ʬ�� (��ȴ������)
(��)
  #{name} 2004_10_10.txt
  �� 2004_10_10.txt.aa, 2004_10_10.txt.ab, �� ���Ǥ���
(���ץ������)
  -prefix=hoge.     �� hoge.aa, hoge.ab, �� ���Ǥ���
  -help �ޤ��� -h   �� ���Υ�å�������ɽ��
EOU
end

#####################################

if ($help || $h || ARGV.length == 0)
  usage
  exit 0
end

$prefix ||= ARGV[0] + '.'
ext = 'aa'

ARGF.readlines.join.split(/^= /).each_with_index{|x, i|
  next if x.empty?
  x = '= ' + x if i > 0
  open($prefix + ext, 'w'){|io| io.print x}
  ext.succ!
}
