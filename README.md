# Flutter OTA DFU

Demo upgrade nRF52832 firmware through BLE on Flutter

Source code device: https://github.com/ptienchuan/nrf52832-ota-dfu

## Setup

1. Nạp source code cho device
2. Chuẩn bị file firmware: Sau khi Pristine Build device, sử dụng file /build/zephyr/app_update.bin (của source code device) để upgrade.
3. Copy file firmware trên vào folder /assets/
4. Run project trên iphone thật.

## Cách test

### Kiểm tra trước khi upgrade

Mục tiêu là kiểm tra xem trạng thái trước khi upgrade thì device đang có bao nhiêu image, image đang active có giống với image sẽ upgrade hay không, nếu giống thì phải active image khác trước khi upgrade để nhìn thấy kết quả thay đổi.

- Kiểm tra danh sách image, change active image: dùng app Device Manager trên mobile của Nordic.
- Test xem image đang active có giống image sẽ upgrade hay không: Dùng CoolTerm hiện log của device, kiểm tra đoạn `build time` (mỗi firmware sẽ giữ build time tại thời điểm build)

### Upgrade

1. Mở Flutter app, chọn `Scan`
2. Chọn `Connect` device sẽ upgrade. (Chỉ những device có broadcast SMP service)
3. Tại màn hình device chọn `Send firmware` để bắt đầu upgrade. Sau khi chọn thì button sẽ ẩn đi và thay vào đó là % upgrade, sau khi send thành công firmware thì sẽ hiển thị `DFU Done`. Lúc này firmware đã được gửi thành công tới device và đã được set ở trạng thái `confirm`.
4. Chọn `Reset` trên flutter app hoặc bấm nút reset vật lý trên board để reset Device. Do firmware mới đã được set trạng thái là `confirm` nên sau khi reset xong, firmware này sẽ được active.

**Lưu ý:**

_Hiện tại sau khi upgrade firmware xong mà chưa tắt app, bấm tiếp nút `Send firmware` có thể phát sinh lỗi làm crash app. Hiện chưa điều tra lỗi này vì package `mcumgr_flutter` đang trong thời gian phát triển, nếu sau khi release ổn định mà vẫn gặp lỗi này thì sẽ phải điều tra._

### Kiểm tra kết quả sau khi upgrade

- Dùng app Device Manager để xem danh sách image, active image. Xác định bằng hash của image.
- Dùng CoolTerm kiểm tra field `build time` của firmware.

## Document

https://developer.nordicsemi.com/nRF_Connect_SDK/doc/2.1.0/zephyr/services/device_mgmt/index.html

### Cơ chế hoạt động

#### mcumgr

nRF Connect SDK sử dụng base trên Zephyr sử dụng library [mcumgr](https://github.com/nrfconnect/sdk-mcumgr) để quản lý `image` và `os`, ...

**`image` management:**
- images state: danh sách image, trạng thái từng image (active, confirm/test, bootable, ...), set trạng thái cho image
- image upload: ghi image vào device
- image erase
- ...

**`os` management:**
- soft reset: reset mcu
- ...

Để ghi image vào deivce, mcumgr sử dụng [SMP Protocol](https://developer.nordicsemi.com/nRF_Connect_SDK/doc/2.1.0/zephyr/services/device_mgmt/smp_protocol.html) thông qua BLE hoặc Shell.

Điều khiển mcumgr bằng cách gửi qua SMP Protocol:
- group_command (image / os / ...)
- command (images state / soft reset / ...)
- data (nếu có)

#### SMP Service

Để transfer data qua SMP Protocol sử dụng BLE thì cần sử dụng [SMP Service](https://docs.zephyrproject.org/latest/services/device_mgmt/smp_transport.html#ble-bluetooth-low-energy)

Mô tả frame để gửi 1 gói tin: https://developer.nordicsemi.com/nRF_Connect_SDK/doc/2.1.0/zephyr/services/device_mgmt/smp_protocol.html

### Package
#### iOS package

https://github.com/NordicSemiconductor/IOS-nRF-Connect-Device-Manager

#### Android package

https://github.com/NordicSemiconductor/Android-nRF-Connect-Device-Manager

#### Flutter package (beta)

https://github.com/NordicSemiconductor/Flutter-nRF-Connect-Device-Manager

#### ~Flutter package cũ~

~https://github.com/NordicSemiconductor/IOS-DFU-Library~

~https://github.com/NordicSemiconductor/Android-DFU-Library~

~Các package DFU là package cũ, chỉ dùng cho SoftDevice (sdk trước nRF Connect SDK).~

Đối với nRF Connect SDK phải sử dụng `mcumgr`
