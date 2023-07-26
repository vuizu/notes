## 一、以累加数字(5000w个数)为案例进行编码

1. 优秀的算法总是高于一切形式上的编码：

    ```java
    (1 + n) * n >> 2; // cost: 0 ms
    
    // 使用外部循环forEach -> cost: 16 ms
    long res = 0L;
    for (int i = 1; i <= n; i++) {
        res += i;
    }
    return res;
    
    // 外部循环无法进行并行化操作，故可以采用Stream流进行内部循环，让内部自动完成并行化过程。
    // 对于较小的数据量，并行处理少数几个元素的好处还抵不上并行化造成的额外开销。
    // 并行流并不总是比顺序流快，所以在考虑顺序流还是并行流时，应使用适当的基准来检查其性能。
    // seq cost: 280 ms, par cost: 616 ms
    Stream.iterate(0L, i -> i + 1)
        .limit(n)
        // .parallel()
        .reduce(0L, Long::sum);
    
    // jdk9推出的新版iterate方法，串并行效率都高于iterate().limit(n)组合
    // seq cost: 251 ms, par cost: 312 ms
    Stream.iterate(0L, i -> i <= n, i -> i + 1)
        // .parallel()
        .reduce(0L, Long::sum);
    ```

2. 由于并行流背后使用的是Java7中引入ForkJoinPool框架，所以将选择易于分解的数据结构创建流（使用Spliterator来切分数据）：

    ```java
    // 由于ArrayList可以平均拆分，而LinkedList需要遍历后才能拆分，故ArrayList的拆分效率较高
    
    // 数值流中的range/rangeClosed的拆分效率也是高于iterate生成的无限流的
    // 根据下面第3点，再来选择range还是iterate
    ```

3. 如果存在大量的拆装箱操作影响性能的话，将在普通流和数值流之间做选择：

    ```java
    // 本案例全是对数值的操作，故数值流是最佳选择
    // 结合上面第2点，得知使用range的效率高于iterate
    // seq cost: 16 ms, par cost: 2 ms
    LongStream.rangeClosed(1L, n)
        // .parallel()
        // .reduce(0L, Long::sum) // 等价于sum()
        .sum();
    
    // 使用iterate的情况
    // seq cost: 16 ms, par cost: 47 ms
    LongStream.iterate(1L, i -> i <= n, i -> i + 1)
        // .parallel()
        .sum();
    
    // 使用普通流的情况下，没有range方法，参考第1点中的最后代码块
    ```

4. 在使用特别是limit和findFirst等依赖于元素顺序的操作时，如果你需要流中的n个元素而不是前n个的话，对无序并行流调用limit可能会比有序流并行流更高效：

    ```java
    // 对比第1点中的代码可知：
    // 对串行流进行打乱反而会增加耗时，但是结果依然正确
    // 对并行流进行打乱会提升效率，但是由于本案例是依赖顺序的，将导致最终结果不正确
    // seq cost: 410 ms, par cost: 420 ms
    Stream.iterate(0L, i -> i + 1)
        .unordered()
        .limit(n)
        // .parallel()
        .reduce(0L, Long::sum);
    
    // 对比第1点中的代码可知：
    // 新API不会受到顺序的影响，故最终结果都是正确的，打乱反而会增加耗时
    // seq cost: 288 ms, par cost: 340 ms
    Stream.iterate(0L, i -> i <= n, i -> i + 1)
        .unordered()
        // .parallel()
        .reduce(0L, Long::sum);
    
    // findAny在并行流上会比findFirst性能好，因为它不一定要按顺序来执行
    ```

5. 改变了某些共享状态，会影响并行流以及并行计算，所以要避免共享可变状态，确保并行Stream得到正确的结果。

    ```java
    // 在并行操作中，由于有共享变量i，且i++不是原子操作，故并行操作会导致最终的计算结果不正确
    // seq cost: 348 ms, par cost: 2495 ms
    Stream.generate(
        new Supplier<Long> {
            long i = 1L;
            @Override
            public Long get() {
                return i++;
            }
        })
        .limit(n)
        // .parallel()
        .reduce(0L, Long::sum);
    ```

有必要的话可以将`sequential()`和`parallel()`在代码中穿插使用。


