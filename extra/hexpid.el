1632
1633
1634
1635
1636
1637
1638
1639
1640
1641
1642
1643
1644
1673
1674
1701
1702
1703
1704
1705
1706
1707
1708
1709
1710
1711
1714
1715
1716
1717
1718
1719
1720
1721
1722
1723
1724
1725
1726
1727
1730
1732
1734
1743
1744
1746
1747
1749
1750
1751
1752
1753
1755
1756
1770
1774
1789
1790
1791
1792
1793
1797
1800
1801
1802
1803
1804
1805
1806
1807
1808
1809
1810
1811
1812
1813
1814
1815
1816
1817
1818
1819
1820
1822
1823
1824
1825
1826
1827
1828
1829
1830
1831
1832
1833
1834
1835
1836
1837
1838
1840
1841
1842
1843
1844
1845
1846
1847
1848
1849
1850
1851
1852
1853
1854
1855
1856
1857
1858
1860
1861
1862
1863
1864
1865
1871
1873
1874
1875
1876
1877
1878
1880
1882
1883
1884
1885
1886
1887
1888
1891
1894
1898
1918
1935
2121
22061
22063
22083
22092
22111
22112
22114
22120
22132
22133
22488
22519
22520
22521
22722



#x168c                                   ; => 5772
(format "%x" 5676)                      ; => "15d5"

(defun listupthread ()
  (interactive)
  (let ((threaddump-buf "t001.txt")
        (threadlist "threadlist.txt"))
    (when (get-buffer threaddump-buf)
      (with-current-buffer (get-buffer-create threadlist)
        (erase-buffer))
      (with-current-buffer (get-buffer threaddump-buf)
        (goto-char (point-min))
        (while (search-forward-regexp "nid=0x\\([0-9|a-f]+\\)" nil t)
          (message "ThreadName,,,1632.%d,java,\"%s\""
                   (string-to-number (match-string 1) 16 )
                   (string-replace "\""
                                   ""
                                   (buffer-substring-no-properties (line-beginning-position)
                                                                   (progn (beginning-of-line)
                                                                          (search-forward "prio=1" nil t)
                                                                          (-  (point) 7)))))
          (end-of-line))))))

;; (listupthread)
