<?php
use app\widgets\Alert;
use yii\helpers\Html;
use yii\bootstrap\Nav;
use yii\bootstrap\NavBar;
use yii\widgets\Breadcrumbs;
use app\assets\AppAsset;

AppAsset::register($this);
?>
<?php $this->beginPage() ?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Login - Demo Zcom Blockchain</title>

    <meta name="description" content="Source code generated using layoutit.com">
    <meta name="author" content="LayoutIt!">
    <?php $this->head() ?>

  </head>
  <body>
  <?php $this->beginBody() ?>
        <div class="header">
            <h1 class="header-icon">
                <span class="visuallyhidden">Twitter</span>
            </h1>
        </div>
        <?= $content ?>
    <?php $this->endBody() ?>
  </body>
</html>
<?php $this->endPage() ?>
