# Copyright (c) 2015-2017, Ruslan Baratov
# All rights reserved.

# !!! DO NOT PLACE HEADER GUARDS HERE !!!

include(hunter_add_package)
include(hunter_download)
include(hunter_generate_qt_info)
include(hunter_pick_scheme)
include(hunter_status_debug)

## 5.5 only --
string(COMPARE EQUAL "qtwayland" "qtquick1" _is_qtquick1)
string(COMPARE EQUAL "qtwayland" "qtwebkit" _is_qtwebkit)
string(COMPARE EQUAL "qtwayland" "qtwebkit-examples" _is_qtwebkit_examples)

if(_is_qtquick1 OR _is_qtwebkit OR _is_qtwebkit_examples)
  if(NOT HUNTER_Qt_VERSION MATCHES "^5\\.5\\.")
    return()
  endif()
endif()
## -- end

## 5.6+ only --
string(COMPARE EQUAL "qtwayland" "qtquickcontrol2" _is_qtquickcontrols2)
string(COMPARE EQUAL "qtwayland" "qtwebview" _is_qtwebview)

if(_is_qtquickcontrols2 OR _is_qtwebview)
  if(HUNTER_Qt_VERSION MATCHES "^5\\.6\\.")
    # Qt 5.6.*
  elseif(HUNTER_Qt_VERSION MATCHES "^5\\.9\\.")
    # Qt 5.6.*
  else()
    return()
  endif()
endif()
## -- end

## 5.9 only --
string(COMPARE EQUAL "qtwayland" "qtcharts" _is_qtcharts)
string(COMPARE EQUAL "qtwayland" "qtdatavis3d" _is_qtdatavis3d)
string(COMPARE EQUAL "qtwayland" "qtdocgallery" _is_qtdocgallery)
string(COMPARE EQUAL "qtwayland" "qtfeedback" _is_qtfeedback)
string(COMPARE EQUAL "qtwayland" "qtgamepad" _is_qtgamepad)
string(COMPARE EQUAL "qtwayland" "qtnetworkauth" _is_qtnetworkauth)
string(COMPARE EQUAL "qtwayland" "qtpim" _is_qtpim)
string(COMPARE EQUAL "qtwayland" "qtpurchasing" _is_qtpurchasing)
string(COMPARE EQUAL "qtwayland" "qtqa" _is_qtqa)
string(COMPARE EQUAL "qtwayland" "qtremoteobjects" _is_qtremoteobjects)
string(COMPARE EQUAL "qtwayland" "qtrepotools" _is_qtrepotools)
string(COMPARE EQUAL "qtwayland" "qtscxml" _is_qtscxml)
string(COMPARE EQUAL "qtwayland" "qtserialbus" _is_qtserialbus)
string(COMPARE EQUAL "qtwayland" "qtspeech" _is_qtspeech)
string(COMPARE EQUAL "qtwayland" "qtsystems" _is_qtsystems)
string(COMPARE EQUAL "qtwayland" "qtvirtualkeyboard" _is_qtvirtualkeyboard)

if(
    _is_qtcharts OR
    _is_qtdatavis3d OR
    _is_qtdocgallery OR
    _is_qtfeedback OR
    _is_qtgamepad OR
    _is_qtnetworkauth OR
    _is_qtpim OR
    _is_qtpurchasing OR
    _is_qtqa OR
    _is_qtremoteobjects OR
    _is_qtrepotools OR
    _is_qtscxml OR
    _is_qtserialbus OR
    _is_qtspeech OR
    _is_qtsystems OR
    _is_qtvirtualkeyboard
)
  if(NOT HUNTER_Qt_VERSION MATCHES "^5\\.9\\.")
    return()
  endif()
endif()
## -- end

if(NOT _HUNTER_INTERNAL_LOADING_QT_DEPENDENCIES)
  # '_depends_on' will return **all** dependencies of the component so there is
  # no need to traverse them recursively (optimization)
  hunter_generate_qt_info(
      "qtwayland"
      _unused_toskip
      _depends_on
      _unused_nobuild
      "${HUNTER_Qt_VERSION}"
      "${ANDROID}"
      "${WIN32}"
  )

  set(_HUNTER_INTERNAL_LOADING_QT_DEPENDENCIES TRUE)
  foreach(_x ${_depends_on})
    hunter_add_package(Qt COMPONENTS ${_x})
  endforeach()
  set(_HUNTER_INTERNAL_LOADING_QT_DEPENDENCIES FALSE)
endif()

# We should call this function again since hunter_add_package is include-like
# instruction, i.e. will overwrite variable values (foreach's _x will survive)
hunter_generate_qt_info(
    "qtwayland"
    _unused_toskip
    _unused_depends_on
    _nobuild
    "${HUNTER_Qt_VERSION}"
    "${ANDROID}"
    "${WIN32}"
)

list(FIND _nobuild "qtwayland" _dont_build_it)
if(NOT _dont_build_it EQUAL -1)
  hunter_status_debug(
      "Qt component doesn't install anything and will be skipped: qtwayland"
  )
  return()
endif()

string(COMPARE EQUAL "qtwayland" "qtdeclarative" _is_qtdeclarative)
if(WIN32 AND _is_qtdeclarative)
  find_program(_python_path NAME "python" PATHS ENV PATH)
  if(NOT _python_path)
    hunter_user_error(
        "Python not found in PATH:\n  $ENV{PATH}\n"
        "Python required for building Qt component (qtdeclarative):\n"
        "  http://doc.qt.io/qt-5/windows-requirements.html"
    )
  endif()
endif()

hunter_pick_scheme(DEFAULT url_sha1_qt)
hunter_download(
    PACKAGE_NAME Qt
    PACKAGE_COMPONENT "qtwayland"
    PACKAGE_INTERNAL_DEPS_ID "11"
)
