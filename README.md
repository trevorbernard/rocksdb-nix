# RocksDB nix flake

There is an issue with linking on aarch64-darwin with rocksbd-nix. The
same configuration works under x86_64-linux.

```
nix build
warning: Git tree '/Users/tbernard/p/granola/rocksdb-nix' is dirty
error: builder for '/nix/store/s7w8mzn8s48g4js3pj9sk7nx9985py2g-rocksdb-nix-0.1.0.drv' failed with exit code 101;
       last 10 log lines:
       >                 rocksdb::ColumnFamilyDescriptor::~ColumnFamilyDescriptor() in liblibrocksdb_sys-912774aaa3cc819f.rlib(c.o)
       >                 std::__1::vector<rocksdb::ColumnFamilyDescriptor, std::__1::allocator<rocksdb::ColumnFamilyDescriptor>>::~vector[abi:v160006]() in liblibrocksdb_sys-912774aaa3cc819f.rlib(c.o)
       >                 std::__1::vector<std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>, std::__1::allocator<std::__1::basic_string<char, std::__1::char_traits<char>, std::__1::allocator<char>>>>::~vector[abi:v160006]() in liblibrocksdb_sys-912774aaa3cc819f.rlib(c.o)
       >                 _rocksdb_column_family_handle_destroy in liblibrocksdb_sys-912774aaa3cc819f.rlib(c.o)
       >                 ...
       >           ld: symbol(s) not found for architecture arm64
       >           clang-16: error: linker command failed with exit code 1 (use -v to see invocation)
       >
       >
       > error: could not compile `rocksdb-nix` (bin "rocksdb-nix") due to previous error
       For full logs, run 'nix-store -l /nix/store/s7w8mzn8s48g4js3pj9sk7nx9985py2g-rocksdb-nix-0.1.0.drv'.

```


