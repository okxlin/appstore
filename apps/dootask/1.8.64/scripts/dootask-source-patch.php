<?php

declare(strict_types=1);

$appRoot = rtrim(getenv('DOOTASK_APP_ROOT') ?: '/var/www', '/');
$releaseFile = $appRoot . '/.1panel-release-version';
$release = trim((string) @file_get_contents($releaseFile));

if ($release !== '' && $release !== '1.8.64') {
    fwrite(STDOUT, "[dootask-source-patch] skip compatibility patch for release {$release}\n");
    exit(0);
}

$patches = [
    'database/migrations/2022_06_19_233120_add_web_socket_dialog_msgs_key.php' => [
        "->text('key')->after('emoji')->nullable()->default('')->comment('搜索关键词');" =>
        "->text('key')->after('emoji')->nullable()->comment('搜索关键词');",
    ],
    'database/migrations/2022_06_24_205033_add_web_socket_dialog_msgs_reply_num.php' => [
        "                ->where('reply_id', '>', 0)\n                ->chunk(100, function (\$lists) {" =>
        "                ->where('reply_id', '>', 0)\n                ->orderBy('reply_id')\n                ->chunk(100, function (\$lists) {",
    ],
    'database/migrations/2022_07_16_161857_add_user_deletes_cache.php' => [
        "->text('cache')->after('reason')->nullable()->default('')->comment('会员资料缓存');" =>
        "->text('cache')->after('reason')->nullable()->comment('会员资料缓存');",
    ],
    'database/migrations/2024_10_23_204404_add_web_socket_dialog_msg_reads_live.php' => [
        "        Schema::table('web_socket_dialog_msgs', function (Blueprint \$table) {\n            \$table->index('deleted_at');\n        });" =>
        "        try {\n            Schema::table('web_socket_dialog_msgs', function (Blueprint \$table) {\n                \$table->index('deleted_at');\n            });\n        } catch (\\Throwable \$e) {\n            if (stripos(\$e->getMessage(), 'Duplicate key name') === false) {\n                throw \$e;\n            }\n        }",
        "                WebSocketDialogMsg::whereType('text')->whereKey(\$key)->update(['key' => '']);" =>
        "                WebSocketDialogMsg::whereType('text')->where('key', \$key)->update(['key' => '']);",
    ],
];

$patchedFiles = [];

foreach ($patches as $relativePath => $replacements) {
    $path = $appRoot . '/' . $relativePath;
    if (!is_file($path)) {
        fwrite(STDOUT, "[dootask-source-patch] missing {$relativePath}, skipping\n");
        continue;
    }

    $contents = file_get_contents($path);
    if ($contents === false) {
        fwrite(STDERR, "[dootask-source-patch] failed to read {$relativePath}\n");
        exit(1);
    }

    $updated = $contents;
    $changed = false;
    foreach ($replacements as $search => $replace) {
        if (str_contains($updated, $search)) {
            $updated = str_replace($search, $replace, $updated);
            $changed = true;
        }
    }

    if (!$changed) {
        continue;
    }

    if (file_put_contents($path, $updated) === false) {
        fwrite(STDERR, "[dootask-source-patch] failed to write {$relativePath}\n");
        exit(1);
    }

    $patchedFiles[] = $relativePath;
}

if ($patchedFiles === []) {
    fwrite(STDOUT, "[dootask-source-patch] no compatibility changes needed\n");
    exit(0);
}

fwrite(
    STDOUT,
    "[dootask-source-patch] applied MySQL 8 compatibility patches to: " . implode(', ', $patchedFiles) . "\n"
);
