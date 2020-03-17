class InfluxdbCxx < Formula
  desc "C++ client library for InfluxDB 1.x/2.x"
  homepage ""
  url "https://github.com/awegrzyn/influxdb-cxx/archive/v0.4.0.tar.gz"
  sha256 "c8f53cb00e99bfe1c5dbea61048891a18fa243a95ed6697660e8bb1217d0b4f7"
  head "https://github.com/awegrzyn/influxdb-cxx.git"

  uses_from_macos "libcurl"
  depends_on "cmake" => :build
  depends_on "boost" => :optional

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "-j"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <InfluxDBFactory.h>
      int main()
      {
        auto influxdb = influxdb::InfluxDBFactory::Get("udp://localhost:8080");
        influxdb->write(influxdb::Point{"test"}
          .addField("value", 10) 
          .addField("value", 20) 
          .addField("value", 100LL)
          .addTag("host", "adampc")
        );  
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17", "-stdlib=libc++", "-o", "test"
    system "./test"
  end
end
