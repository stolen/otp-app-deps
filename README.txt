Tricky app dependencies demo.
Please note: the problem with application start order is observed in OTP 26rc1, not earlier.
Related to https://github.com/erlang/otp/pull/6737

Here are three apps: 'toplevel', 'communicate', 'storage'
  * 'toplevel' has its own boot function which configures other applications before starting them as dependencies
  * 'communicate' only starts successfully when configured by 'toplevel'
  * 'storage' requires 'communicate' only when configured by 'toplevel'
  * 'storage' may be used as utility without 'communicate'

Application start order depends on the order of their names loaded as atoms. In this case 'storage' is added before 'communicate'
Without strong 'storage' dependencies the boot function fails because 'storage' is started before 'communicate'
Making 'storage' depend strongly on 'communicate' breaks utility use (`make util`)

Reproduce toplevel start failure:
  * comment out 'communicate' in apps/storage/src/storage.app.src, 'applications' section
  * make; make boot  -- 'storage' fails to start because 'communicate' is not started
  * doing this with OTP 25 leads to no failure

Reproduce utility start failure:
  * make sure 'communicate' is in apps/storage/src/storage.app.src, 'applications' section
  * make; make util  -- 'communicate' fails to start, 'storage' fails to start too despite optional_applications are specified
