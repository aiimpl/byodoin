# 平等院鳳凰堂 CAD → Blender 動画
#   make all      図面・巻物の図・音・タイトル・シーンまで（数十秒）
#   make test     要所の 5 コマを半分の解像度で描く（数分）
#   make render   本番 480 コマ（M5 の Mac で約 1 時間 40 分）
#   make video    コマ＋タイトル＋音を build/byodoin.mp4 に

PYTHON  ?= python3
BLENDER ?= blender

.PHONY: all dxf dxf-preview scroll audio title scene test camera render video clean

all: dxf scroll audio title scene

dxf:
	$(PYTHON) cad/make_dxf.py

dxf-preview: dxf
	$(PYTHON) cad/preview.py

scroll:
	$(PYTHON) drawing/make_scroll.py

audio:
	$(PYTHON) sound/make_audio.py

title:
	$(PYTHON) finish/make_title.py

scene: scroll
	$(BLENDER) -b --factory-startup -P scene/build.py

test:
	$(BLENDER) -b build/byodoin.blend -P tools/test_frames.py -- 61,150,250,400,504 50

camera:
	$(BLENDER) -b build/byodoin.blend -P tools/check_camera.py

render:
	tools/render_chunks.sh

video:
	finish/compose.sh

clean:
	rm -rf build
