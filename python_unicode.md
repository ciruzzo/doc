
まず、文字コードは内部の表現と、入出力が別であって、内部表現はstr型である。これはunicodeでもある。str型はunicodeと同じでpython3では区別がない。入出力できる文字コードはsjisやutf-8などである。これらの型がbytes型である。
つまり、ファイルの内容や、ファイル名などはbytes型としてプログラムに入ってくるので、必要に応じてstr型に変換する必要がある。

変換は、

- str -&gt; bytesとするのをencode、
- bytes -&gt; strとするのがdecode

となっている。内部表現のstr型が中心だと思えば覚えられるだろう。

要素として、

- 関数が受け付ける型
- ファイルの中身
- ファイル名
- ロケールとprint()がやってくれる処理

ということが同時に登場するので、混乱するのだと（少なくとも私は）思う。

### 情報

- [公式](http://docs.python.jp/3/howto/unicode.html)のページが丁寧だった。
- こちらの偉い人が書かれた[記事](http://lab.hde.co.jp/2008/08/pythonunicodeencodeerror.html)
も有用だった。
- 先ほどこちらの[記事](http://python-notes.curiousefficiency.org/en/latest/python3/text_file_processing.html)
を見つけたが、まだちゃんと読んではいない。

### 基本編
```
string = 'アイウエオ'
type(string)　# str
print(string) # アイウエオ
ustring = u'アイウエオ' #python3では'u'をつける必要はない。つけても怒られない
type(ustring) # str
print(string==ustring) # True
```

### 変換
```
bytestr = bytes(string) # TypeErrorで失敗
# エンコードを指定してエンコードする必要
bytestr = bytes(string, 'utf-8')
bytestr2 = string.encode('utf-8')

print(bytestr==bytestr2) # True　この2つは同じことのようだ。

print(bytestr) #b'\xe3\x82\xa2\xe3\x82\xa4\xe3\x82\xa6\xe3\x82\xa8\xe3\x82\xaa'
```

### ファイルへの出力

#### デフォルトのコーディングで出力

```f=open('Desktop/test_text.txt','w')
# writeに渡すのはstr
f.write(string)
# f.write(bytestr) # TypeError: write() argument must be str, not bytes
f.close()
```

#### 確認してみる。
```
# $ file Desktop/test_text.txt
# Desktop/test_text.txt: UTF-8 Unicode text, with no line terminators
```

#### 以下のように出力のコーディングを指定できる。
```
f=open('Desktop/test_text_sjis.txt','w',encoding='sjis')
f.write(string)
f.close()
```

#### str型をprint()に渡して、処理してくれる場合と、できない場合がある。
```
print(string) #この場合はOK. アイウエオ
```

#### utf-8を手で入力してみる。
```
T = b'\xe3\x80\x92' #e3 80 92
print(T.decode()) # 郵便マーク　〒
```

#### サマリア文字というのがあるらしいので、ついでにそれも入力してみる。
```
samaria = b'\xe0\xa0\x80'
print(samaria.decode()) # Samaritan サマリア文字　　ࠀ
```

#### デフォルトのコーディングが上記のようにutf-8ならば変換してくれるが、以下のようにロケールがASCIIになっていると、UnicodeEncodeErrorで失敗する。
```
$ LANG=C
$ python3
Python 3.5.1 (default, Dec 31 2015, 09:25:09)
[GCC 4.2.1 Compatible Apple LLVM 7.0.0 (clang-700.1.76)] on darwin
Type "help", "copyright", "credits" or "license" for more information.

>>> t = b'\xe3\x80\x92' #e3 80 92　郵便マーク
>>> print(t.decode())
Traceback (most recent call last):
  File "", line 1, in
UnicodeEncodeError: 'ascii' codec can't encode character '\u3012' in position 0: ordinal not in range(128)

>>> samaria = b'\xe0\xa0\x80'
>>> print(samaria.decode())
Traceback (most recent call last):
  File "", line 1, in
UnicodeEncodeError: 'ascii' codec can't encode character '\u0800' in position 0: ordinal not in range(128)
```

#### decodeでのコード指定。間違ったコードを指定すると、エラーが返る。
```
print(T.decode('sjis'))

UnicodeDecodeError: 'shift_jis' codec can't decode byte 0x92 in position 2: incomplete multibyte sequence
```

