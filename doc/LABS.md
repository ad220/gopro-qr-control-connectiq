# GoPro Labs features
## Video Settings
### Resolutions: 
Resolutions are also in the format rX(Y) - where X is the first character of the resolution, and the optional Y is aspect ratio, T - Tall 4:3, X - eXtreme 8:7, nothing is 16:9
 * `r1` or `r10` or `r1080`  - 1920x1080
 * `r1T` or `r14` or `r1440`  - 1920x1440
 * `r1V` - 1080x1920 HD Vertical Video (H13)
 * `r2` or `r27` - for 2.7K 16x9
 * `r2T` or `r27T` - for 2.7K Tall the 4x3 mode
 * `r3` - 3K 360° for GoPro MAX
 * `r4` - 4k 16x9
 * `r4T` - 4k Tall, the 4:3 mode
 * `r4X` - 4k eXtreme, the 8:7 mode (H11-13)
 * `r4S` - 4k Square, the 1:1 mode using Ultra Wide (H13)
 * `r4V` - 2160x3840 4K Vertical Video (H13)
 * `r5` - 5.3k for HERO and 5.6K 360° for GoPro MAX
 * `r5T` - 5k Tall, the 4:3 mode (H10)
 * `r5X` - 5k eXtreme, the 8:7 mode (H11-13)
 
### Frame rates: 
 * `p24` - 24 fps
 * `p25` - 25 fps
 * `p30` - 30 fps
 * `p50` - 50 fps
 * `p60` - 60 fps
 * `p100` - 100 fps
 * `p120` - 120 fps
 * `p200` - 200 fps
 * `p240` - 240 fps
 * (only supports existing frame rates, so p65 or p1000 will be ignored.)
  
### Timelapse and NightLapse frame rates: 
 * `p2` (0.5s or 2Hz/2p capture)
 * `p1` (1s interval)
 * `p.2` (2s interval) 
 * `p.3600` (1 hour interval) 
 * (only supports existing frame rates, so p.1234 will be ignored.)

### Lens - FOV: 
 * `fN` - Narrow (older models)
 * `fM` - Medium (older models)
 * `fW` - Wide
 * `fL` - Linear
 * `fS` - Superview 
 * `fV` - HyperView (H11-13)
 * `fH` - Horizonal Level + Linear (H9-13)
 * `fX` - SuperMax Wide (Max Lens Mod)

### EIS (Hypersmooth control): 
 * `e0` - Off     
 * `e1` or just `e` - On
 * `e2` - High
 * `e3` - Boost
 * `e4` - Auto

### Hindsight (Video modes H9-13): 
 * `hS0` - Off     
 * `hS1` - On 15s window
 * `hS2` - On 30s window
 * `hS5` - Experimental Labs H11-13 - 5s window

## Protune
### Audio (Raw controls): 
 * `aL` - Low Processing
 * `aM` - Medium Processing
 * `aH` - High Processing

### Bitrate: 
 * `b0` - Standard Bitrate
 * `b1` - High Bitrate

### Color: 
 * `cF` - Color Flat
 * `cG` - Color Vibrant (old GoPro Color)
 * `cN` - Color Natural (H10-13)

### Depth (H11/12 only): 
 * `d0` or `d8` - 8-bit color
 * `d1` or `d10` - 10-bit color
 
### Exposure Lock: 
 * `eL0` - Off     
 * `eL1` - On
 * `eL2` to `eL9` -  Lock after 2 to 9 seconds.

### White Balance (only this WB settings): 
### White Balance (only this WB settings): 
 * `wA` - Auto White Balance
 * `w23` - 2300K White balance
 * `w28` - 2800K 
 * `w32` - 3200K 
 * `w40` - 4000K 
 * `w45` - 4500K 
 * `w50` - 5000K 
 * `w55` - 5500K 
 * `w60` - 6000K 
 * `w65` - 6500K 
 * `wN` - Native White Balance

### ISO Minimum and Maximum (set to together with format i(max)M(min)):
(All cameras and Older Labs):<br>
 * `i1M1` - 100 ISO Max & Min
 * `i64M16` - 6400 ISO Max with 1600 ISO Min
 * `i1S180` - 100 ISO Max with a 180 degree shutter angle
 * `i1S0` - 100 ISO Max with an **Automatic** shutter angle<br>

### EV Compensation: 
 * `x0` - EV 0 default
 * `x-.5` - EV -0.5
 * `x.5` - EV +0.5
 * `x-1` - EV -1.0
 * `x1` - EV +1.0
 
### Sharpness: 
 * `sL` - Low
 * `sM` - Medium
 * `sH` - High
 

## Extended controls
### Camera settings
* **64BT** H8-10/M1-2: 12GB Chapter sizes on HERO8/9/10 and MAX cameras (default on H11+), 64GB chapters on MAX2. Note: Will not be active for QuickCaptures. Input Data: 1-enable, 0-disable WARNING: Larger chapters will not playback on camera or support USB transfers, but are compatible with desktop tools. Permanent required. e.g. `*64BT=1`
* **64BT** H11-13/M2: These camera default to 12GB Chapter sizes, but support larger. Note: Will not be active for QuickCaptures. Input Data: x-size in MBs, 0-disable. Permanent required. e.g. `*64BT=32000` for 32GB chapters.
* **ARCH** H8-13/M1-2: Archive mode: an ultra simplified video camera mode for novices documenting critical events, where you don’t want the camera mode modified. Either button will start and stop video capture. Input Data: 1-enable, 0-disable WARNING: only removable via the disable command. Permanent required. e.g. `*ARCH=1`
* **BERS** H10-13: Bypass ERS compensation, extremely rare usecases. Input Data: 0-display, 1-enable, 2-enable only with EIS off e.g. `*BERS=2`
* **BYPS** H11-13/M1-2: Bypass common pop-ups, such as resetting the time and date. Remember to set time and date if you remove the battery. Input Data: 1 to bypass, 0 for normal notifications. e.g. `*BYPS=1`
* **CBAR** H9-13: enable a small 75% saturated color bars for video tools evaluation. Most cameras limit overlays to 4K30, 2.7Kp60 or lower. Input Data: 1 to enable, 0 to disable
* **HIST** H7-13/M1-2: Enable a histogram with with a range of contrast options. Input Data: Number 1 to 11 enables the histogram with contrast 1 through 11, 0 will disable it. e.g. `$HIST=5`
* **LBAR** H9-13: enable a small luma sweep for video tools evaluation. Most cameras limit overlays to 4K30, 2.7Kp60 or lower. Input Data: 1 to enable, 0 to disable
* **LEVL** H11-13/M1-2: enable on-screen spirit level. Input Data: 1-9 sets the size of the level, 0 to disable.  e.g. `*LEVL=5`
* **SPED** H8-13/M1-2: SD Card Speed Test. Data rates should have minimums above 120Mb/s is you want to reliably capture the high bitrate modes.Input Data: 1-9, number of times to run the test.
* **SYNC** H9-11,13/M1-2: GPS time/timecode sync. With a good GPS signal, the camera’s internal clock will be precisely updated to the millisecond. It will not update the hour or date, preserving your current timezone offset. Input Data: 1-enable, 0-disable. Permanent required. e.g. `*SYNC=1`
* **TONE** H10-13/M2: Tone-mapping controls. Input Data:   0 - current defaults   1 - global tone-mapping only   2 - both tone-mapping   3 - disable all tone-mapping
* **TUSB** H10-13/M2: Trust USB power. Some USB power sources may report less than they are capable. This modification assumes the USB Power source is 2A minimum, and disables the testing. If you use TUSB with an inadequate power source, expect capture failures. e.g. `*TUSB=1`
* **WAKE** H9-13/M1-2: Conditional wake on any power addition. Inserting a battery or the connection of USB power, will boot up the camera to continue a script after a power failure.  Input Data: 1-wake if there is a delay action pending, 2-wake on power, 0-disable  e.g. `*WAKE=2`
* **ZONE** H9-13/M1-2: Set the time zone for use with SYNC. Input Data: time zone offset in minutes.

### Video settings
* **24HZ** H10-13/M2: enable film standard 24.0 frame, rather than the default broadcast standard 23.976. The existing 24p mode(s) will have the new frame rate when this is enabled, all other video modes are unaffected. Input Data: 1-enable, 0-disable. e.g. `*24HZ=1`
* **BITR** H10-13/M1-2: set the compression in Mb/s for the Protune High Bitrate setting. Normally this would be around 100Mb/s, however higher (or lower) rates may be achieved with newer SD Cards.Input Data: MB/s from 2 to 200. e.g. `*BITR=180`
* **BITH** H10-12: set the compression for LRVs in Mb/s. Normally this would be around 4Mb/s, however higher (or lower) rates may be achieved with newer SD Cards. Input Data: MB/s from 1 to 100. 
* **BITL** H11-13: controlling the livestream maximum bitrate (up to 8Mbit/s). Input Data: MB/s from 1 to 8.
* **DLRV** H10-11: Disable LRV file creation. Application: high bit-rate drones video. Input Data: 1 to disable LRVs, 0 to re-enable. e.g. `*DLRV=1` to permanently disable LRV files.
* **EVBS** H10-13/M1-2: This is an EV compensation value that works with webcam and livestreaming, it can be changed live (with QRDR=1) and it is global, adding the any existing EV control in your presets.Input Data: range -4 to 4.
* **EXPQ** H11-13/M1-2: Min and Max Shutter speed, 1/x format. Input Data: 24 to 8000, representing 1/24 and 1/8000s, 0 to disable. e.g. `$EXPQ=120`
* **EXPS** H11-13/M1-2: Video exposure values: ISO and Shutter speed, rendered to the LCD. Handy for those using ND Filters. Input Data: 1 to enable, 0 to disable (2 smoother rendering.) 
* **EXPX** H10-13/M1-2: maX EXPosure time (longest shutter), 1/x format. Input Data: 24 to 8000, representing 1/24 and 1/8000s, 0 to disable. e.g. `$EXPX=120`
* **EXPN** H10-13/M1-2: miN EXPosure time (shortest shutter), 1/x format. Input Data: 24 to 8000, representing 1/24 and 1/8000s, 0 to disable.  e.g. `$EXPN=240`
* **EXPT** H7-13/M1-2: Video Exposure Control through Maximum Shutter Angle for video modes. Can improve stabilization in low light. Input Data: Number 0 through 5 stops.  0-360° (camera default), 1-180°, 2-90°, 3-45°, 4-22.5° etc.
* **GCMP** H11-13/M1-2: Disable Gryo Compensated Exposure.  When GoPro camera modes, it normally uses a faster shutter for improved stabilization, this control disables this feature.Input Data: 1 to disable gyro comp, 0 - default
* **LOGB** H11-13/M2: Extremely advanced users. Change the Log base for very flat encoding. Color Flat is Log base 113. Math:out = log(in*(base-1)+1)/log(b). Should be combined with Flat and 10-bit settings. Input Data: base,[offset]e.g. 200,-128 or 400. e.g. $LOGB=400 for GPLog equivalent
* **NR01** H11-13/M2: Noise reduction control, for advanced user intending noise reduction in post. Likely needs a higher BITR. Input Data: 1-100, is the default full denoise processing in camera. 1 - leaves the most noise. 0 - disables e.g. `$NR01=1` for maximum noise (denoise off)
* **PRXY** H10-13: Store LRV files as NLE ready proxies. Normally a camera will encode an LRV (Low Res Video) for every MP4, with this enabled LRVs are made MP4s within a subfolder. Input Data: 1-move LRVs, 2-move THMs, 3-both, (v2.1) 4-No _Proxy name. 0-disable
* **WBLK** H11-13/M2: White balance Lock upon capture. Allows the convenience of auto white balance, without the risk of WB change during capture. Input Data: 1-enable WB Lock, 0-disable
* **WIDE** H11-13/M2: A wide gamut color profile, this supports all in-camera white balancing. Like using white balance Native, without as much post color work. Input Data: 1-enable WIDE gamut, 0-disable e.g. `$WIDE=1`

### Audio settings
* **AUDS** H10-13: Audio Level: displays the current estimate of the sound pressure level in dB. Input Data: 1-enable, 0-disable. e.g. `$AUDS=1`
* **DAUD** H10-13: Disable Audio in video captures, all MP4 files will have no audio track. Application: high bit-rate drones video.Input Data: 1 to disable audio, 0 to re-enable
* **GAIN** H9-13: Digitally gain up the audio. e.g. \$GAIN=12, increase audio by 12dB. Will likely reduce the dynamic range.Input Data: 0-48 in dB.
* **MUTE** H9-13: Mute one or more channels of audio. e.g. \$MUTE=15 mutes all channels, for a single channel use 1 = first, 2 = second, 4 = third and 8 = fourth channelInput Data: 0-15, the value is binary mask.
* **SOLO** H9-13: Use only one channel of audio. e.g. `$SOLO=1` use only channel 1, `$SOLO=4` use only channel 4.Input Data: 0-4, the value is a channel number.

### Labs I/O
* **DBGL** H8-13/M1-2: Enables more debug logging. Labs saves it logs to the SD card under MISC/qrlog.txt. Using this extension increases the details and logged events. e.g. To see more logging from boot up use `*DBGL=1`
* **DSPC** H7-13/M1-2: Labs text display contrast. Set the background opacity for Labs text on the LCD. Input Data: Number from 0-transparent to 6-completely opaque.
* **DSPL** H7-13/M1-2: Labs text display length. How long to display each Labs message, like owner information (OWNR). The default is 1 second. Input Data: Number from 1-9 seconds or 10-9999 milliseconds.
* **FAST** H10-13/M1-2: Faster and fewer Labs notifications on boot. Input Data: 1-enable, 0-disable. e.g. `*FAST=1`
* **FEAT** H10-13/M1-2: Displays Labs enabled Features for x seconds. Input Data: x-seconds.  e.g. `$FEAT=4`
