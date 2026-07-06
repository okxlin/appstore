<?php

declare(strict_types=1);

use App\Module\Base;
use App\Module\Doo;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

require '/var/www/vendor/autoload.php';

$app = require '/var/www/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

function merge_defaults(array $existing, array $defaults): array
{
    foreach ($defaults as $key => $value) {
        if (is_array($value)) {
            if (!isset($existing[$key]) || !is_array($existing[$key]) || $existing[$key] === []) {
                $existing[$key] = $value;
                continue;
            }
            $existing[$key] = merge_defaults($existing[$key], $value);
            continue;
        }
        if (!array_key_exists($key, $existing) || $existing[$key] === null || $existing[$key] === '') {
            $existing[$key] = $value;
        }
    }
    return $existing;
}

$systemDefaults = [
    'reg' => 'open',
    'project_invite' => 'open',
    'login_code' => 'auto',
];

$priorityDefaults = [
    [
        'name' => '重要且紧急',
        'color' => '#ED4014',
        'days' => 1,
        'priority' => 1,
        'is_default' => 1,
    ],
    [
        'name' => '重要不紧急',
        'color' => '#F16B62',
        'days' => 3,
        'priority' => 2,
        'is_default' => 0,
    ],
    [
        'name' => '紧急不重要',
        'color' => '#19C919',
        'days' => 5,
        'priority' => 3,
        'is_default' => 0,
    ],
    [
        'name' => '不重要不紧急',
        'color' => '#2D8CF0',
        'days' => 0,
        'priority' => 4,
        'is_default' => 0,
    ],
];

$emailDefaults = [
    'smtp_server' => '',
    'port' => '',
    'account' => '',
    'password' => '',
    'reg_verify' => 'close',
    'notice_msg' => 'close',
    'msg_unread_user_minute' => -1,
    'msg_unread_group_minute' => -1,
    'msg_unread_time_ranges' => [[]],
    'ignore_addr' => '',
];

$thirdAccessDefaults = [
    'ldap_open' => 'close',
    'ldap_port' => 389,
    'ldap_login_attr' => 'cn',
    'ldap_sync_local' => 'close',
];

$systemSetting = Base::setting('system');
Base::setting('system', merge_defaults(is_array($systemSetting) ? $systemSetting : [], $systemDefaults));

$prioritySetting = Base::setting('priority');
if (!is_array($prioritySetting) || $prioritySetting === []) {
    Base::setting('priority', $priorityDefaults);
}

$emailSetting = Base::setting('emailSetting');
Base::setting('emailSetting', merge_defaults(is_array($emailSetting) ? $emailSetting : [], $emailDefaults));

$thirdAccessSetting = Base::setting('thirdAccessSetting');
Base::setting('thirdAccessSetting', merge_defaults(is_array($thirdAccessSetting) ? $thirdAccessSetting : [], $thirdAccessDefaults));

if ((int) DB::table('users')->count() === 0) {
    $email = getenv('DOOTASK_ADMIN_EMAIL') ?: 'admin@example.com';
    $password = getenv('DOOTASK_ADMIN_PASSWORD') ?: 'ChangeMe123!';
    $nickname = getenv('DOOTASK_ADMIN_NICKNAME') ?: 'Administrator';
    $encrypt = substr(md5($email), 0, 6);
    $initial = strtoupper(substr($email, 0, 1));
    if ($initial === '' || !preg_match('/[A-Z]/', $initial)) {
        $initial = 'A';
    }
    $now = Carbon::now();

    $row = [
        'identity' => ',admin,',
        'az' => $initial,
        'email' => $email,
        'nickname' => $nickname,
        'profession' => '管理员',
        'userimg' => '',
        'encrypt' => $encrypt,
        'password' => Doo::md5s($password, $encrypt),
        'changepass' => 1,
        'login_num' => 0,
        'last_ip' => '',
        'last_at' => null,
        'line_ip' => '',
        'line_at' => null,
        'task_dialog_id' => 0,
        'created_ip' => '',
        'created_at' => $now,
        'updated_at' => $now,
    ];

    if (Schema::hasColumn('users', 'department')) {
        $row['department'] = '';
    }
    if (Schema::hasColumn('users', 'pinyin')) {
        $row['pinyin'] = '';
    }
    if (Schema::hasColumn('users', 'tel')) {
        $row['tel'] = '';
    }
    if (Schema::hasColumn('users', 'disable_at')) {
        $row['disable_at'] = null;
    }
    if (Schema::hasColumn('users', 'email_verity')) {
        $row['email_verity'] = 1;
    }
    if (Schema::hasColumn('users', 'bot')) {
        $row['bot'] = 0;
    }
    if (Schema::hasColumn('users', 'lang')) {
        $row['lang'] = '';
    }
    if (Schema::hasColumn('users', 'birthday')) {
        $row['birthday'] = null;
    }
    if (Schema::hasColumn('users', 'address')) {
        $row['address'] = null;
    }
    if (Schema::hasColumn('users', 'introduction')) {
        $row['introduction'] = null;
    }

    DB::table('users')->insert($row);
}
