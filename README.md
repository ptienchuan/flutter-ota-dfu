# Flutter OTA DFU
Demo upgrade nRF52832 firmware through BLE on Flutter
// TODO: link device demo

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

### Cơ chế hoạt động

mcumgr
SMP protocol
SMP Service
iOS package
Android package
Flutter package
