class SparkLibrdkafka < Formula
  desc "https://github.com/trialspark/librdkafka"
  url "https://github.com/trialspark/librdkafka/archive/3258bb85a4bee6e1f6c572eb4eff074098f2da6c.tar.gz"
  version "1.9.2-1"
  sha256 "0623af690a8158ff038dd17568746532a9e96dc9cef8e56b230614c58e4263ed"

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl@1.1"
  depends_on "zstd"

  uses_from_macos "curl"
  uses_from_macos "cyrus-sasl"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>

      int main (int argc, char **argv)
      {
          int partition = RD_KAFKA_PARTITION_UA; /* random */
          int version = rd_kafka_version();
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
