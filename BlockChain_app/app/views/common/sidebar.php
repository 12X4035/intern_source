<?php
use yii\helpers\Html;
?>
<nav id="sidebar">
    <?= Html::a('<div class="sidebar-header"><h3>Hello ' . ((Yii::$app->user->identity->nickname) ? Yii::$app->user->identity->nickname : 'user') . '</h3></div>', ['post/index']) ?>
    <ul class="list-unstyled components">
        <p>Personal Address: <span><?= (Yii::$app->user->identity->personaladdress) ? '0x' . Yii::$app->user->identity->personaladdress : '' ?></span></p>
        <p id="currentPersonalToken">Personal Token: 0 HDO</p>
	<p>Pool Address: <span><?= (Yii::$app->user->identity->pooladdress) ? '0x' . Yii::$app->user->identity->pooladdress : '' ?></span></p>
        <p id="currentPoolToken">Pool Token: 0 HDO</p>
        <input type="hidden"  id="yourEmail" value="<?= Yii::$app->user->identity->mail_address ?>">
        <input type="hidden"  id="yourAddress" value="<?= Yii::$app->user->identity->personaladdress ?>">
	<input type="hidden"  id="yourPoolAddress" value="<?= Yii::$app->user->identity->pooladdress ?>">
    </ul>
    <ul class="list-unstyled CTAs">
        <li><?= Html::a('Setting Personal', ['user/setting']) ?></li>
        <li><?= Html::a('Setting Pool', ['user/settingpool']) ?></li>
	<li><a href="#" class="download">Sent gift HDO</a></li>
        <li><?= Html::a('Logout', ['user/logout']) ?></li>
    </ul>
</nav>
